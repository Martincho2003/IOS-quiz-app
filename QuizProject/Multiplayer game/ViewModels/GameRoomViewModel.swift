//
//  GameRoomViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import Foundation
import Combine

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
                .sink { res in
                    switch res {
                    case .failure(_):
                        print("error")
                    default: break
                    }
                } receiveValue: { [self] getRoom in
                    room = getRoom
                }
                .store(in: &subscriptions)
        } else {
            multiplayerService.joinRoom(admin: roomName)
            multiplayerService.getRoom(admin: roomName)
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
}
