//
//  StringToDifficulty.swift
//  QuizProject
//
//  Created by Martin Dinev on 8.03.22.
//

import Foundation

extension String {
    var toDifficulty: Difficulty {
        if (self == "hard" || self == "Hard"){
            return .hard
        }
        return .easy
    }
}
