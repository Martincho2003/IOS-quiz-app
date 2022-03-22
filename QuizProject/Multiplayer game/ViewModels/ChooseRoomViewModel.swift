//
//  ChooseRoomViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import Foundation
import Combine
import FirebaseDatabase

class ChooseRoomViewModel: ObservableObject {
    var multiplayerSrevice = MultiplayerGameService()
    var subscriptions = Set<AnyCancellable>()
    @Published var rooms: [Room] = []
    
    init(){
        multiplayerSrevice.getAllRooms()
            .sink { res in
                switch res {
                case .finished:
                    print("nice")
                case .failure(_):
                    print(res)
                }
            } receiveValue: { [self] roomsFIR in
                rooms = roomsFIR
            }
            .store(in: &subscriptions)
        refreshRooms()

    }
    
    private func refreshRooms() {
        Database.database().reference()
            .child("rooms")
            .observe(.childAdded) { [self] _ in
                multiplayerSrevice.getAllRooms()
                    .sink { res in
                        switch res {
                        case .finished:
                            print("nice")
                        case .failure(_):
                            print(res)
                        }
                    } receiveValue: { [self] roomsFIR in
                        rooms = roomsFIR
                    }
                    .store(in: &subscriptions)
            }
    }
}
