//
//  Room.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import Foundation

struct Room: Hashable {
    var admin: SessionUserDetails
    var subjects: [String]
    var difficutlies: [String]
    var users: [SessionUserDetails]
    var questions: [NewQuestion]
    var is_game_started: String
}
