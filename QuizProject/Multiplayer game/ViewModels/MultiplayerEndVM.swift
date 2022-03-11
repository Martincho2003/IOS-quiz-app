//
//  MultiplayerEndVM.swift
//  QuizProject
//
//  Created by Martin Dinev on 10.03.22.
//

import Foundation
import FirebaseDatabase
import Combine

class MultiplayerEndVM: ObservableObject {
    @Published var room: Room
    @Published var users: [RoomUser] = []
    private var multiplayerService = MultiplayerGameService()
    private var subscriptions = Set<AnyCancellable>()
    
    init(room: Room) {
        self.room = room
        refreshRoom(admin: room.admin.username)
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
                        case .finished:
                            multiplayerService.getRoomUsersFromRoom(admin: room.admin.username)
                                .sink { res in
                                    switch res {
                                    case .failure(_):
                                        print(res)
                                    default: break
                                    }
                                } receiveValue: { roomUsers in
                                    users = roomUsers
                                }
                                .store(in: &subscriptions)
                        }
                    } receiveValue: { [self] getRoom in
                        room = getRoom
                    }
                    .store(in: &subscriptions)
            }
    }
}
