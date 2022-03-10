//
//  GameRoomViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import Foundation
import Combine
import FirebaseDatabase

class GameRoomViewModel: ObservableObject {
    var asCreator: Bool
    var roomName: String = ""
    var subscriptions = Set<AnyCancellable>()
    private var multiplayerService = MultiplayerGameService()
    @Published var room: Room = Room(admin: SessionUserDetails(username: "", points: -1, last_day_played: "", played_games: -1), subjects: [], difficutlies: [], users: [], questions: [], is_game_started: "no")
    
    init(asCreator: Bool, subjects: [Subject], diffs: [Difficulty], roomName: String) {
        self.roomName = roomName
        self.asCreator = asCreator
        if (asCreator){
            multiplayerService.createRoom(subjects: subjects, diffs: diffs)
                .sink { [self] res in
                    switch res {
                    case .failure(_):
                        print("error")
                    case .finished:
                        refreshRoom(admin: room.admin.username)
                    }
                } receiveValue: { [self] getRoom in
                    room = getRoom
                }
                .store(in: &subscriptions)
        } else {
            multiplayerService.joinRoom(admin: roomName)
            refreshRoom(admin: roomName)
        }
    }
    
    private func refreshRoom(admin: String) {
        Database.database().reference()
            .child("rooms/\(admin)")
            .observe(.childChanged) { [self] _ in
                multiplayerService.getRoom(admin: admin)
                    .sink { res in
                        switch res {
                        case .failure(_):
                            print("error2")
                        default: break
                        }
                    } receiveValue: { [self] getRoom in
                        room = getRoom
                    }
                    .store(in: &subscriptions)
            }
    }
    
    func isStartDisabled() -> Bool {
        if (room.users.count < 2) {
            return true
        }
        return false
    }
    
    func startGame() {
        multiplayerService.startGameRoom(admin: room.admin.username)
    }
}
