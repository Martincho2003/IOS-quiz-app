//
//  ChooseRoomViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import Foundation

class ChooseRoomViewModel: ObservableObject {
    @Published var rooms: [Room] = []
}
