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
    
    private func questionsToDictionary(_ questions: [NewQuestion]) -> [[String:Any]]{
        var questionsArrDict: [[String: Any]] = []
        for question in questions {
            questionsArrDict.append(["question": question.question,
                                     "answers": answerstoDictionary(question.answers),
                                     "difficulty": question.difficulty.rawValue])
            
        }
        return questionsArrDict
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
    
    func getRoom(admin: String) -> AnyPublisher<Room, Error> {
        Deferred {
            Future { promise in
                Database.database().reference().child("rooms/\(admin)")
                    .getData { error, snapshot in
                        guard error == nil else {
                            promise(.failure(error!))
                            print(error!.localizedDescription)
                            return;
                        }
                        let value = snapshot.value as? [String:Any]
                        let admin = value?["admin"] as? SessionUserDetails
                        print(admin)
//                        let room = Room(admin: <#T##SessionUserDetails#>, subjects: <#T##[String]#>, difficutlies: <#T##[String]#>, users: <#T##[SessionUserDetails]#>, questions: <#T##[NewQuestion]#>, is_game_started: <#T##String#>)
//                        promise(.success(room))
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
