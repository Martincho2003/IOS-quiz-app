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
    private var cancellable = Set<AnyCancellable>()
    private var service: GameService
    @Published var currentQuestion: Int = 0
    @Published var seconds: [Int] = []
    var points = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(service: GameService, subjects: [Subject], diffs: [Difficulty]){
        self.service = service
        service.getQuestionsFromPub(difficulties: diffs, subjects: subjects)
            .sink { error in
            print(error)
        } receiveValue: { [self] question in
            questions.append(contentsOf: question)
            question.forEach { quest in
                if (quest.difficulty == .hard){
                seconds.append(40)
                }else{
                    seconds.append(20)
                }
                
            }
        }
        .store(in: &cancellable)
    }
    
    func checkAnswer(_ answer: NewAnswer) {
        if (answer.is_correct != "") {
            if (questions[currentQuestion].difficulty == .hard) {
                points += 8
            } else {
                points += 4
            }
        }
        if (currentQuestion == 9) {
            service.sendPoints(points)
        }
        currentQuestion += 1
    }
    
    func checkSeconds() {
        if (seconds[currentQuestion] == 0) {
            if (currentQuestion == 9) {
                service.sendPoints(points)
            }
            currentQuestion += 1
        }
    }
}
