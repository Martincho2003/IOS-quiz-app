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
    var difficulties: [Difficulty] = []
    
    func reloadDifficulties() {
        if (isCheckedHard) {
            difficulties.append(.hard)
        } else {
            for i in 0..<difficulties.count {
                if ( difficulties[i] == .hard) {
                    difficulties.remove(at: i)
                    break
                }
            }
        }
        if (isCheckedEasy) {
            difficulties.append(.easy)
        } else {
            for i in 0..<difficulties.count {
                if ( difficulties[i] == .easy) {
                    difficulties.remove(at: i)
                    break
                }
            }
        }
        
    }
    
    func refreshBooleans() {
        isCheckedEasy = false
        isCheckedHard = false
    }
    
    func sendDifficulties() -> [Difficulty] {
        reloadDifficulties()
        print(difficulties)
        return difficulties
    }
    
    func isCreateDisabled() -> Bool {
        if (isCheckedHard && isCheckedEasy){
            return false
        }
        return true
    }
}
