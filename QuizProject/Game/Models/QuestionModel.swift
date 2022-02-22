//
//  QuestionModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 21.02.22.
//

import Foundation

struct NewQuestion {
    var question: String
    var answers: [NewAnswer]
    var difficulty: Difficulty
}
