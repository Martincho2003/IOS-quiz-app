//
//  GameService.swift
//  QuizProject
//
//  Created by Martin Dinev on 21.02.22.
//

import Foundation
import FirebaseDatabase

enum Difficulty {
    case easy
    case random
    case hard
}

enum Subject: CaseIterable {
    case random
    case biology
}

class GameService {
    private var questions: [NewQuestion] = []
    
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
    
    private func getFullyRandomQuestions() -> NewQuestion{
        let randDifficulty = Int.random(in: 0...1)
        let randSubject = 0//Int.random(in: 0...1)
        var newQuestion = NewQuestion(question: "", answers: [], difficulty: .random)
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
        return newQuestion
    }
    
    private func getQuestionsBySubject(_ subjects: [Subject]){
        
    }
        
    func getQuestions(difficulty: Difficulty, subjects: [Subject]) -> [NewQuestion] {
        for subject in subjects {
            if (subject == .random) {
                if (difficulty == .random){
                        sleep(2)
                }
            }
        }
        return questions
    }
    
    func checkAnswer(_ answer: NewAnswer) -> Bool {
        if (answer.is_correct != ""){
            return true
        }
        return false
    }
}
