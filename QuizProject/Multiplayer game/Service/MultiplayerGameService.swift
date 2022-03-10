//
//  MultiplayerGameService.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Combine

class MultiplayerGameService {
    private var gameService: GameService = GameService()
    private var subscriptions = Set<AnyCancellable>()
    
    private func userToDictionary(user: SessionUserDetails) -> [String:Any]{
        return [
            "username": user.username,
            "room_points": 0,
            "points": user.points,
            "last_day_played": user.last_day_played,
            "played_games": user.played_games]
        
    }
    
    private func usersToArrDictionary(users: [SessionUserDetails]) -> [[String: Any]]{
        var usersDict: [[String:Any]] = []
        for user in users {
            usersDict.append(userToDictionary(user: user))
        }
        return usersDict
    }
    
    private func dictionaryToUser(userDict: [String:Any]) -> SessionUserDetails {
        return SessionUserDetails(username: userDict["username"] as! String,
                                  points: userDict["points"] as! Int,
                                  last_day_played: userDict["last_day_played"] as! String,
                                  played_games: userDict["played_games"] as! Int)
    }
    
    private func dictionaryToUsersArr(usersArrDict: [[String:Any]]) -> [SessionUserDetails] {
        var users: [SessionUserDetails] = []
        for user in usersArrDict {
            users.append(SessionUserDetails(username: user["username"] as! String,
                                            points: user["points"] as! Int,
                                            last_day_played: user["last_day_played"] as! String,
                                            played_games: user["played_games"] as! Int))
        }
        return users
    }
    
    private func readDictionaryToUsersArr(usersArrDict: [String:[String:Any]]) -> [SessionUserDetails] {
        var users: [SessionUserDetails] = []
        for (_, user) in usersArrDict {
            users.append(SessionUserDetails(username: user["username"] as! String,
                                            points: user["points"] as! Int,
                                            last_day_played: user["last_day_played"] as! String,
                                            played_games: user["played_games"] as! Int))
        }
        return users
    }
    
    private func subjectsToString(_ subjects: [Subject]) -> [String]{
        var subjectsArr: [String] = []
        for subject in subjects {
            subjectsArr.append(subject.title)
        }
        return subjectsArr
    }
    
    private func difficultiesToString(_ diffs: [Difficulty]) -> [String]{
        var diffsArr: [String] = []
        for diff in diffs {
            diffsArr.append(diff.value)
        }
        return diffsArr
    }
    
    private func answerstoDictionary(_ answers: [NewAnswer]) -> [[String:String]] {
        var answersArrDict: [[String:String]] = []
        for answer in answers {
            answersArrDict.append(["answer": answer.answer,
                                   "is_correct": answer.is_correct])
        }
        return answersArrDict
    }
    
    private func dictionaryToAnswers(answersArrDict: [[String:String]]) -> [NewAnswer]{
        var answers: [NewAnswer] = []
        
        for answer in answersArrDict {
            answers.append(NewAnswer(answer: answer["answer"]!,
                                     is_correct: answer["is_correct"]!))
        }
        
        return answers
    }
    
    private func questionsToDictionary(_ questions: [NewQuestion]) -> [[String:Any]]{
        var questionsArrDict: [[String: Any]] = []
        for question in questions {
            questionsArrDict.append(["question": question.question,
                                     "answers": answerstoDictionary(question.answers),
                                     "difficulty": question.difficulty.rawValue])
            
        }
        return questionsArrDict
    }
    
    private func dictionaryToQuestionArr(questionsArrDict: [[String:Any]]) -> [NewQuestion] {
        var questions: [NewQuestion] = []
        for question in questionsArrDict {
            questions.append(NewQuestion(question: question["question"] as! String,
                                         answers: dictionaryToAnswers(answersArrDict: question["answers"] as! [[String : String]]),
                                         difficulty: ((question["difficulty"]) as! String).toDifficulty))
        }
        return questions
    }
    
    func createRoom(subjects: [Subject], diffs: [Difficulty]) -> AnyPublisher<Room,Error> {
        Deferred {
            Future { [self] promise in
                var userInfo: SessionUserDetails = SessionUserDetails(username: "", points: -1, last_day_played: "", played_games: -1)
                var questions: [NewQuestion] = []
                gameService.getQuestionsFromPub(difficulties: diffs, subjects: subjects)
                    .sink { [self] res in
                        switch res {
                        case .finished :
                            gameService.getUserDetails()
                                .sink { userRes in
                                    switch userRes {
                                    case .finished :
                                        let room = Room(admin: userInfo, subjects: subjectsToString(subjects), difficutlies: difficultiesToString(diffs), users: [userInfo], questions: questions, is_game_started: "no")
                                        Database.database().reference()
                                            .child("rooms")
                                            .child(userInfo.username)
                                            .setValue(["admin" : userToDictionary(user: userInfo),
                                                       "users" : [userToDictionary(user: userInfo)],
                                                       "subjects" : room.subjects,
                                                       "difficulties" : room.difficutlies,
                                                       "questions" : questionsToDictionary(room.questions),
                                                       "is_game_started": room.is_game_started])
                                        promise(.success(room))
                                    case .failure(_) :
                                        print(userRes)
                                    }
                                } receiveValue: { userDetails in
                                    userInfo = userDetails
                                }
                                .store(in: &subscriptions)
                        case .failure :
                            print(res)
                        }
                    } receiveValue: { quests in
                        questions.append(contentsOf: quests)
                    }
                    .store(in: &subscriptions)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getAllRooms() -> AnyPublisher<[Room], Error> {
        Deferred {
            Future { promise in
                Database.database().reference()
                    .child("rooms")
                    .getData { [self] error, snapshot in
                        guard error == nil else {
                            promise(.failure(error!))
                            print(error!.localizedDescription)
                            return;
                        }
                        var rooms: [Room] = []
                        let value = snapshot.value as? [String:[String:Any]]
                        for (_, room) in value ?? [:] {
                            rooms.append(Room(admin: dictionaryToUser(userDict: room["admin"] as! [String : Any]),
                                              subjects: room["subjects"] as! [String],
                                              difficutlies: room["difficulties"] as! [String],
                                              users: dictionaryToUsersArr(usersArrDict: room["users"] as! [[String : Any]]),
                                              questions: dictionaryToQuestionArr(questionsArrDict: room["questions"] as! [[String : Any]]),
                                              is_game_started: room["is_game_started"] as! String))
                        }
                        promise(.success(rooms))
                    }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getRoom(admin: String) -> AnyPublisher<Room, Error> {
        Deferred {
            Future { promise in
                Database.database().reference().child("rooms/\(admin)")
                    .getData { [self] error, snapshot in
                        guard error == nil else {
                            promise(.failure(error!))
                            print(error!.localizedDescription)
                            return;
                        }
                        let value = snapshot.value as? [String:[String:Any]]
                        for (key, room) in value ?? [:] {
                            if (key == admin){
                                let admin = room["admin"] as? [String:Any]
                                let subjects = room["subjects"] as? [String]
                                let difficulties = room["difficulties"] as? [String]
                                let users = room["users"] as? [[String:Any]]
                                let questions = room["questions"] as? [[String:Any]]
                                let isGameStarted = room["is_game_started"] as? String
                                let room = Room(admin: dictionaryToUser(userDict: admin!), subjects: subjects!, difficutlies: difficulties!, users: dictionaryToUsersArr(usersArrDict: users!), questions: dictionaryToQuestionArr(questionsArrDict: questions!), is_game_started: isGameStarted!)
                                promise(.success(room))
                            }
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func getRoomUsers(admin: String) -> AnyPublisher<[SessionUserDetails], Error> {
        Deferred {
            Future { promise in
                Database.database().reference().child("rooms/\(admin)")
                    .getData { [self] error, snapshot in
                        guard error == nil else {
                            promise(.failure(error!))
                            print(error!.localizedDescription)
                            return;
                        }
                        let value = snapshot.value as? [String:[String:Any]]
                        for (key, room) in value ?? [:] {
                            if (key == admin){
                                let users = room["users"] as? [[String:Any]]
                                promise(.success(dictionaryToUsersArr(usersArrDict: users!)))
                            }
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func joinRoom(admin: String) {
        var userInfo: SessionUserDetails = SessionUserDetails(username: "", points: -1, last_day_played: "", played_games: -1)
        var roomUsers: [SessionUserDetails] = []
        gameService.getUserDetails()
            .sink { [self] userRes in
                switch userRes {
                case .finished :
                    getRoomUsers(admin: admin)
                        .sink { allUsersRes in
                            switch allUsersRes {
                            case .finished:
                                roomUsers.append(userInfo)
                                Database.database().reference()
                                    .child("rooms/\(admin)")
                                    .updateChildValues(["users": usersToArrDictionary(users: roomUsers)])
                            case .failure(_):
                                print(allUsersRes)
                            }
                        } receiveValue: { users in
                            roomUsers.append(contentsOf: users)
                        }
                        .store(in: &subscriptions)
                case .failure(_) :
                    print(userRes)
                }
            } receiveValue: { userDetails in
                userInfo = userDetails
            }
            .store(in: &subscriptions)
    }
}
