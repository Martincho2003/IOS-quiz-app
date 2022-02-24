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
    var cancellable = Set<AnyCancellable>()
    var service: GameService
    @Published var currentQuestion: Int = 0
    @Published var seconds: Int = 20
    
    init(service: GameService, subjects: [Subject], diffs: [Difficulty]){
        self.service = service
        service.getQuestionsFromPub(difficulties: diffs, subjects: subjects)
            .sink { error in
            print(error)
        } receiveValue: { [self] question in
            questions.append(contentsOf: question)
        }
        .store(in: &cancellable)
    }
    
    func checkAnswer(_ answer: NewAnswer) -> Bool {
        if (answer.is_correct != ""){
            currentQuestion += 1
            return true
        }
        currentQuestion += 1
        return false
    }
}
