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
    @Published var isCheckdHard: Bool = false
    private var difficulties: [Difficulty] = []
    
    private func reloadDifficulties() {
        if (isCheckdHard) {
            difficulties.append(.hard)
        }
        if (isCheckedEasy) {
            difficulties.append(.easy)
        }
    }
    
    func sendDifficulties() -> [Difficulty] {
        reloadDifficulties()
        print(difficulties)
        //sendthem to another view
        return difficulties
    }
}
