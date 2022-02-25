//
//  Subjects.swift
//  QuizProject
//
//  Created by Martin Dinev on 23.02.22.
//

import Foundation

enum Subject: String, CaseIterable {
    case biology = "biology"
}
extension Subject {
    var title: String {
        switch self {
        case .biology:
            return "Biology"
        }
    }
}
