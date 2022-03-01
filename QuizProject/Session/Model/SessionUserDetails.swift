//
//  SessionUserDetails.swift
//  QuizProject
//
//  Created by Martin Dinev on 30.01.22.
//

import Foundation

struct SessionUserDetails: Hashable {
    let username: String
    var points: Int
    var last_day_played: String
    var played_games: Int
}
