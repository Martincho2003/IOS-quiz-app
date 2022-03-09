//
//  ChooseRoomViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import Foundation
import Combine

class ChooseRoomViewModel: ObservableObject {
    var multiplayerSrevice = MultiplayerGameService()
    var subscription = Set<AnyCancellable>()
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
                rooms.append(contentsOf: roomsFIR)
            }
            .store(in: &subscription)

    }
}
