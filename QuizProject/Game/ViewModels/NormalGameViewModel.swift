//
//  NormalGameViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 18.02.22.
//

import Foundation
import FirebaseDatabase
import Combine
import SwiftUI

final class NormalGameViewModel: ObservableObject {
    @Published var questions: [NewQuestion] = []
    @ObservedObject private var sessionService: SessionServiceImpl
    private var cancellable = Set<AnyCancellable>()
    private var gameService: GameService = GameService()
    @Published var currentQuestion: Int = 0
    @Published var seconds: [Int] = []
    var points = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var isAddTime: [Bool] = []
    @Published var isExclude: [Bool] = []
    
    init(sessionService: SessionServiceImpl,
         subjects: [Subject], diffs: [Difficulty]){
        self.sessionService = sessionService
        gameService.getQuestionsFromPub(difficulties: diffs, subjects: subjects)
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
                isAddTime.append(false)
                isExclude.append(false)
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
        currentQuestion += 1
    }
    
    func checkSeconds() {
        if (seconds[currentQuestion] == 0) {
            currentQuestion += 1
        }
    }
    
    func addTime() {
        seconds[currentQuestion] += 20
        if (questions[currentQuestion].difficulty == .hard){
            points -= 2
        } else {
            points -= 1
        }
        isAddTime[currentQuestion].toggle()
    }
    
    func excludeAnswers(){
        while (questions[currentQuestion].answers.count != 2){
            for _ in 0..<questions[currentQuestion].answers.count {
                let rand = Int.random(in: 0..<questions[currentQuestion].answers.count)
                if(questions[currentQuestion].answers[rand].is_correct == ""){
                    questions[currentQuestion].answers.remove(at: rand)
                    break;
                }
            }
        }
        if (questions[currentQuestion].difficulty == .hard){
            points -= 4
        } else {
            points -= 2
        }
        isExclude[currentQuestion].toggle()
    }
    
    func isExcludeDeactivated() -> Bool {
        if (questions[currentQuestion].difficulty == .hard){
            if (sessionService.userDetails!.points + points < 4) {
                return true
            } else {
                return isExclude[currentQuestion]
            }
        } else {
            if (sessionService.userDetails!.points + points < 2) {
                return true
            } else {
                return isExclude[currentQuestion]
            }
        }
    }
    
    func isAddTimeDeactivated() -> Bool {
        if (questions[currentQuestion].difficulty == .hard){
            if (sessionService.userDetails!.points + points < 2) {
                return true
            } else {
                return isAddTime[currentQuestion]
            }
        } else {
            if (sessionService.userDetails!.points + points < 1) {
                return true
            } else {
                return isAddTime[currentQuestion]
            }
        }
    }
}
