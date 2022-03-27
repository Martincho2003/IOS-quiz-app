//
//  MultiplayerQuestionVM.swift
//  QuizProject
//
//  Created by Martin Dinev on 10.03.22.
//

import Foundation
import Combine
import FirebaseDatabase

class MultiplayerQuestionVM: ObservableObject {
    private let ref = Database.database().reference()
    private var refHandle: DatabaseHandle!
    var currentUser: SessionUserDetails = SessionUserDetails(username: "", points: -1, last_day_played: "", played_games: -1)
    @Published var room: Room
    @Published var user: RoomUser = RoomUser(username: "", gamePoints: 0, isFinished: "no")
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
            .sink { [self] res in
                switch res {
                case .failure(_):
                    print(res)
                case .finished:
                    refreshRoom(admin: room.admin.username)
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
    
    private func refreshRoom(admin: String) {
        refHandle = ref
            .child("rooms/\(admin)")
            .observe(.childChanged) { [self] _ in
                service.getRoom(admin: admin)
                    .sink { res in
                        switch res {
                        case .failure(_):
                            print("error2")
                        case .finished:
                            service.getRoomUserFromRoom(admin: room.admin.username, username: currentUser.username)
                                .sink { res in
                                    switch res {
                                    case .failure(_):
                                        print(res)
                                    default: break
                                    }
                                } receiveValue: { roomUser in
                                    user = roomUser
                                    if (roomUser.isFinished == "yes"){
                                        ref.child("rooms/\(admin)").removeObserver(withHandle: refHandle)
                                    }
                                }
                                .store(in: &cancellable)
                        }
                    } receiveValue: { [self] getRoom in
                        room = getRoom
                    }
                    .store(in: &cancellable)
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
        if (currentQuestion == 9) {
            service.setRoomPoints(admin: room.admin.username, user: currentUser, points: points)
        }
        currentQuestion += 1
    }
    
    func checkSeconds() {
        if (seconds[currentQuestion] == 0) {
            if (currentQuestion == 9) {
                service.setRoomPoints(admin: room.admin.username, user: currentUser, points: points)
            }
            currentQuestion += 1
        }
    }
    
    func addTime() {
        seconds[currentQuestion] += 20
        if (room.questions[currentQuestion].difficulty == .hard){
            points -= 2
        } else {
            points -= 1
        }
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
        if (room.questions[currentQuestion].difficulty == .hard){
            points -= 4
        } else {
            points -= 2
        }
        isExclude[currentQuestion].toggle()
    }
    
    func isExcludeDeactivated() -> Bool {
        if (room.questions[currentQuestion].difficulty == .hard){
            if (currentUser.points + points < 4) {
                return true
            } else {
                return isExclude[currentQuestion]
            }
        } else {
            if (currentUser.points + points < 2) {
                return true
            } else {
                return isExclude[currentQuestion]
            }
        }
    }
    
    func isAddTimeDeactivated() -> Bool {
        if (room.questions[currentQuestion].difficulty == .hard){
            if (currentUser.points + points < 2) {
                return true
            } else {
                return isAddTime[currentQuestion]
            }
        } else {
            if (currentUser.points + points < 1) {
                return true
            } else {
                return isAddTime[currentQuestion]
            }
        }
    }
}
