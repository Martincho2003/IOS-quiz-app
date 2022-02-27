//
//  HomeViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 23.02.22.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var showGameMode: Bool = false
    @Published var isGame: Bool = false
    @Published var diffVM: DifficultyViewModel = DifficultyViewModel()
    @Published var subVM: SubjectViewModel = SubjectViewModel()

    func sendSubjects() -> [Subject] {
        subVM.sendSubjects()
    }
    
    func sendDiffs() -> [Difficulty] {
        diffVM.sendDifficulties()
    }
}
