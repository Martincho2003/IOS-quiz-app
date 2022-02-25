//
//  Dificulties.swift
//  QuizProject
//
//  Created by Martin Dinev on 23.02.22.
//

import Foundation

enum Difficulty: String, CaseIterable {
    case easy = "easy"
    case hard = "hard"
}
extension Difficulty {
    var value : String {
        switch self {
        case .easy:
            return "Easy"
        case .hard:
            return "Hard"
        }
    }
}
