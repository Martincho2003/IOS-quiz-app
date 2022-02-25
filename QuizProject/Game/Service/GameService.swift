//
//  GameService.swift
//  QuizProject
//
//  Created by Martin Dinev on 21.02.22.
//

import Foundation
import FirebaseDatabase
import Combine

class GameService {
    private var questions: [NewQuestion] = []
    var cancellable = Set<AnyCancellable>()
    
    private func getFullyRandomQuestions() -> AnyPublisher<NewQuestion,Error>{
        Deferred {
            Future { promise in
                let difficulty = Difficulty.allCases.randomElement()
                let ref = Database.database().reference()
                ref
                    .child("questions/\(Subject.allCases.randomElement()!.rawValue)/\(difficulty?.rawValue ?? "easy")")
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
                if (subjects.count == Subject.allCases.count) {
                    if (difficulties.count == Difficulty.allCases.count){
                        for _ in 0..<10 {
                            getFullyRandomQuestions().sink { error in
                                print(error)
                                if( questionsP.count == 10){
                                    promise(.success(questionsP))
                                }
                            } receiveValue: { question in
                                questionsP.append(question)
                            }
                            .store(in: &cancellable)
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func checkAnswer(_ answer: NewAnswer) -> Bool {
        if (answer.is_correct != ""){
            return true
        }
        return false
    }
}
