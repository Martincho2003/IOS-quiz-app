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
            "points": user.points]
        
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
    
    func createRoom(subjects: [Subject], diffs: [Difficulty]) {
        var userInfo: SessionUserDetails = SessionUserDetails(username: "", points: -1, last_day_played: "", played_games: -1)
        var questions: [NewQuestion] = []
        gameService.getQuestionsFromPub(difficulties: diffs, subjects: subjects)
            .sink { [self] res in
                switch res {
                case .finished :
                    gameService.getUserDetails()
                        .sink { res in
                            switch res {
                            case .finished :
                                
                                let room = Room(admin: userInfo, subjects: subjectsToString(subjects), difficutlies: difficultiesToString(diffs), users: [userInfo], questions: questions)
                                Database.database().reference()
                                    .child("rooms")
                                    .child(userInfo.username)
                                    .setValue(["admin" : userToDictionary(user: userInfo),
                                               "users" : [userToDictionary(user: userInfo)],
                                               "subjects" : room.subjects,
                                               "difficulties" : room.difficutlies,
                                               "questions" : questionsToDictionary(room.questions)])
                            case .failure(_) :
                                print(res)
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
                print(questions)
            }
            .store(in: &subscriptions)
    }
    
//    private func getQuestionIndexes(subjects: [Subject], diffs: [Difficulty]) -> AnyPublisher<[String], Error> {
//        Deferred {
//            Future { promise in
//                var questions: [String] = []
//                let difficulty = diffs.randomElement()
//                let ref = Database.database().reference()
//                ref
//                    .child("questions/\(subjects.randomElement()?.rawValue ?? "biology")/\(difficulty?.rawValue ?? "easy")")
//                    .getData(completion: { error, questionAnswer in
//                        guard error == nil else {
//                            promise(.failure(error!))
//                            print(error!.localizedDescription)
//                            return;
//                        }
//                        let value = questionAnswer.value as? [[String:Any]]
//                        let questionNumber = (value?.count ?? 10) as Int
//                        let randQuestion = Int.random(in: 0..<questionNumber)
//                        let question = value?[randQuestion]
//                        var newQuestion = NewQuestion(question: "", answers: [], difficulty: difficulty ?? .easy)
//                        newQuestion.question = question?["question"] as? String ?? "no question"
//                        let answersArray = question?["answers"] as? [[String:String]] ?? []
//
//                        for answer in answersArray {
//                            let newAnswer = NewAnswer(answer: answer["answer"] ?? "", is_correct: answer["is_correct"] ?? "")
//                            newQuestion.answers.append(newAnswer)
//                        }
//                        promise(.success(newQuestion))
//                    })
//            }
//        }
//    }
//
////    func getRoom(admin: String) -> AnyPublisher<Room, Error> {
////        Deferred {
////            Future { promise in
////                Database.database().reference()
////                    .child("rooms/\(admin)")
////                    .observe(.value) { snapshot in
////                        let value = snapshot?.value as [String:Any]
////                        let
////                    }
////            }
////        }
////    }
//    private func SubjectToString(subjects: [Subject]) -> [String] {
//        var strings: [String] = []
//        for subject in subjects {
//            strings.append(subject.title)
//        }
//        return strings
//    }
//
//    private func DifficultyToString(diffs: [Difficulty]) -> [String] {
//        var strings: [String] = []
//        for diff in diffs {
//            strings.append(diff.value)
//        }
//        return strings
//    }
}
