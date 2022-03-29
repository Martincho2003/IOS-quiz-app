//
//  GameService.swift
//  QuizProject
//
//  Created by Martin Dinev on 21.02.22.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Combine

class GameService {
    var cancellable = Set<AnyCancellable>()
    
    private func getFullyRandomQuestions(subjects: [Subject], diffs: [Difficulty]) -> AnyPublisher<NewQuestion,Error>{
        Deferred {
            Future { promise in
                let difficulty = diffs.randomElement()
                let ref = Database.database().reference()
                ref
                    .child("questions/\(subjects.randomElement()?.rawValue ?? "biology")/\(difficulty?.rawValue ?? "easy")")
                    .getData(completion: { error, questionAnswer in
                        guard error == nil else {
                            promise(.failure(error!))
                            print(error!.localizedDescription)
                            return;
                        }
                        let value = questionAnswer.value as? [[String:Any]]
                        let questionNumber = (value?.count ?? 10) as Int
                        let randQuestion = Int.random(in: 0..<questionNumber)
                        let question = value?[randQuestion]
                        var newQuestion = NewQuestion(question: "", answers: [], difficulty: difficulty ?? .easy)
                        newQuestion.question = question?["question"] as? String ?? "no question"
                        let answersArray = question?["answers"] as? [[String:String]] ?? []
                        
                        for answer in answersArray {
                            let newAnswer = NewAnswer(answer: answer["answer"] ?? "", is_correct: answer["is_correct"] ?? "")
                            newQuestion.answers.append(newAnswer)
                        }
                        promise(.success(newQuestion))
                    })
            }
        }
        .eraseToAnyPublisher()
    }
        
    func getQuestionsFromPub(difficulties: [Difficulty], subjects: [Subject]) -> AnyPublisher<[NewQuestion], Error> {
        Deferred {
            Future { [self] promise in
                var questionsP: [NewQuestion] = []
                for _ in 0..<10 {
                    getFullyRandomQuestions(subjects: subjects, diffs: difficulties)
                        .sink { res in
                            switch res {
                            case .finished :
                                if( questionsP.count == 10){
                                    if (questionsP.uniqued().count == 10){
                                    promise(.success(questionsP))
                                    } else {
                                        questionsP = questionsP.uniqued()
                                        for _ in 0..<10 {
                                            getFullyRandomQuestions(subjects: subjects, diffs: difficulties)
                                                .sink { res in
                                                    switch res {
                                                    case .finished :
                                                        if( questionsP.count == 10){
                                                            promise(.success(questionsP))
                                                        }
                                                    case .failure(_):
                                                        print(res)
                                                    }
                                                } receiveValue: { question in
                                                    questionsP.append(question)
                                                }
                                                .store(in: &cancellable)
                                        }
                                    }
                                }
                            case .failure(_):
                                print(res)
                            }
                        } receiveValue: { question in
                            questionsP.append(question)
                        }
                        .store(in: &cancellable)
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getUserDetails() -> AnyPublisher<SessionUserDetails,Error>{
        Deferred {
            Future { promise in
                let userID = Auth.auth().currentUser!.uid
                let ref = Database.database().reference()
                ref.child("users/\(userID)")
                    .getData { error, users in
                        guard error == nil else {
                            promise(.failure(error!))
                            print(error!.localizedDescription)
                            return;
                        }
                        let value = users.value as? [String:[String:Any]]
                        for (key, user) in value ?? [:] {
                            if (key == userID){
                                let username = user["username"] as? String
                                let points = user["points"] as? Int
                                let day = user["last_day_played"] as? String
                                let times = user["played_games"] as? Int
                                promise(.success(SessionUserDetails(username: username ?? "",
                                                                    points: points ?? 0,
                                                                    last_day_played: day ?? "",
                                                                    played_games: times ?? 0)))
                            }
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func sendPoints(_ gamePoints: Int) {
        let userID = Auth.auth().currentUser!.uid
        var userInfo: SessionUserDetails? = nil
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy"
        getUserDetails()
            .sink { res in
                switch res {
                case .finished:
                    let ref = Database.database().reference().child("users/\(userID)")
                    if (gamePoints < 0) {
                        ref.updateChildValues(["points": userInfo!.points + gamePoints,
                                               "played_games": userInfo!.played_games + 1])
                    } else {
                        if (Calendar.current.isDate(format.date(from: userInfo!.last_day_played)!,
                                                    equalTo: Date(), toGranularity: .day)) {
                            if (userInfo!.played_games < 3) {
                                ref.updateChildValues(["points": userInfo!.points + gamePoints,
                                                       "played_games": userInfo!.played_games + 1])
                            }
                        } else {
                            ref.updateChildValues(["points": userInfo!.points + gamePoints,
                                                            "last_day_played": format.string(from: Date()),
                                                            "played_games": 1])
                        }
                    }
                case .failure(_):
                    print(res)
                }
            } receiveValue: { details in
                userInfo = details
            }
            .store(in: &cancellable)
    }
}
