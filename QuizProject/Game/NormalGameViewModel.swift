//
//  NormalGameViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 18.02.22.
//

import Foundation
import FirebaseDatabase
import Combine


final class NormalGameViewModel: ObservableObject {
    @Published var questions: [NewQuestion] = []
    var service: GameService
    @Published var currecntQuestion: Int = 0
    @Published var seconds: Int = 20
    
    init(service: GameService){
        self.service = service
        for _ in 0..<10 {
            getFullyRandomQuestions()
        }
    }
    
    private func getRandomDifficulty(_ num: Int) -> String {
        if (num == 1){
            return "hard"
        }
        return "easy"
    }
    
    private func getRandomSubject(_ num: Int) -> String {
        if (num == 0) {
            return "biology"
        }
        return "random"
    }
    
    private func getFullyRandomQuestions(){
        let randDifficulty = Int.random(in: 0...1)
        let randSubject = 0//Int.random(in: 0...1)
        var newQuestion = NewQuestion(question: "", answers: [], difficulty: .easy)
        if (randDifficulty == 1){
            newQuestion.difficulty = .hard
            seconds = 40
        }
        let ref = Database.database().reference()
        ref
        .child("questions/\(getRandomSubject(randSubject))/\(randDifficulty)/\(getRandomDifficulty(randDifficulty))")
        .observe(.value) { [self] questionAnswer in
            let value = questionAnswer.value as? [NSDictionary]
            let questionNumber = (value?.count ?? 0) as Int
            let randQuestion = Int.random(in: 0..<questionNumber)
            let question = value?[randQuestion]
            newQuestion.question = question?["question"] as? String ?? "no question"
            let answersArray = question?["answers"] as? [[String:String]] ?? []
            
            for answer in answersArray {
                let newAnswer = NewAnswer(answer: answer["answer"] ?? "", is_correct: answer["is_correct"] ?? "")
                newQuestion.answers.append(newAnswer)
            }
            questions.append(newQuestion)
        }
    }
    
    func checkAnswer(_ answer: NewAnswer) -> Bool {
        if (answer.is_correct != ""){
            currecntQuestion += 1
            return true
        }
        currecntQuestion += 1
        return false
    }
}
