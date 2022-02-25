//
//  DifficultyViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 23.02.22.
//

import Foundation
import Combine

final class DifficultyViewModel: ObservableObject {
    @Published var isCheckedEasy: Bool = false
    @Published var isCheckedHard: Bool = false
    private var difficulties: [Difficulty] = []
    
    private func reloadDifficulties() {
        if (isCheckedHard) {
            difficulties.append(.hard)
        }
        if (isCheckedEasy) {
            difficulties.append(.easy)
        }
    }
    
    func sendDifficulties() -> [Difficulty] {
        reloadDifficulties()
        print(difficulties)
        return difficulties
    }
}
