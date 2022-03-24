//
//  UniqueArray.swift
//  QuizProject
//
//  Created by Martin Dinev on 24.03.22.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
