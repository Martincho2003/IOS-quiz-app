//
//  MultiplayerQuestionVM.swift
//  QuizProject
//
//  Created by Martin Dinev on 10.03.22.
//

import Foundation
import Combine

class MultiplayerQuestionVM: ObservableObject {
    var currentUser: SessionUserDetails = SessionUserDetails(username: "", points: -1, last_day_played: "", played_games: -1)
    @Published var room: Room
    private var cancellable = Set<AnyCancellable>()
    private var service: MultiplayerGameService = MultiplayerGameService()
    @Published var currentQuestion: Int = 0
    @Published var seconds: [Int] = []
    var points = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var isAddTime: [Bool] = []
    @Published var isExclude: [Bool] = []
    
    init(room: Room){
        self.room = room
        service.gameService.getUserDetails()
            .sink { res in
                switch res {
                case .failure(_):
                    print(res)
                default: break
                }
            } receiveValue: { details in
                self.currentUser = details
            }
            .store(in: &cancellable)

        for question in room.questions {
            if (question.difficulty == .hard){
                seconds.append(40)
            } else {
                seconds.append(20)
            }
            isAddTime.append(false)
            isExclude.append(false)
        }
    }
    
    func checkAnswer(_ answer: NewAnswer) {
        if (answer.is_correct != "") {
            if (room.questions[currentQuestion].difficulty == .hard) {
                points += 8
            } else {
                points += 4
            }
        }
//        if (currentQuestion == 9) {
//            service.sendPoints(points)
//        }
        currentQuestion += 1
    }
    
    func checkSeconds() {
        if (seconds[currentQuestion] == 0) {
//            if (currentQuestion == 9) {
//                service.sendPoints(points)
//            }
            currentQuestion += 1
        }
    }
    
    func addTime() {
        seconds[currentQuestion] += 20
        points -= 2
        isAddTime[currentQuestion].toggle()
    }
    
    func excludeAnswers(){
        while (room.questions[currentQuestion].answers.count != 2){
            for _ in 0..<room.questions[currentQuestion].answers.count {
                let rand = Int.random(in: 0..<room.questions[currentQuestion].answers.count)
                if(room.questions[currentQuestion].answers[rand].is_correct == ""){
                    room.questions[currentQuestion].answers.remove(at: rand)
                    break;
                }
            }
        }
        points -= 4
        isExclude[currentQuestion].toggle()
    }
    
    func isExcludeDeactivated() -> Bool {
        if (currentUser.points + points < 4) {
            return true
        } else {
            return isExclude[currentQuestion]
        }
    }
    
    func isAddTimeDeactivated() -> Bool {
        if (currentUser.points + points < 2) {
            return true
        } else {
            return isAddTime[currentQuestion]
        }
    }
}
