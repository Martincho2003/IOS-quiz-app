//
//  MultiplayerEndVM.swift
//  QuizProject
//
//  Created by Martin Dinev on 10.03.22.
//

import Foundation

class MultiplayerEndVM: ObservableObject {
    @Published var users: [RoomUser]
    
    init(users: [RoomUser]) {
        self.users = users
    }
}
