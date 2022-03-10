//
//  GameRoomViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import Foundation

final class MultiplayerHomeVM: ObservableObject {
    @Published var showGameDetails = false
    @Published var isCreateActive = false
    @Published var diffVM: DifficultyViewModel = DifficultyViewModel()
    @Published var subVM: SubjectViewModel = SubjectViewModel()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    func sendSubjects() -> [Subject] {
        subVM.sendSubjects()
    }
    
    func sendDiffs() -> [Difficulty] {
        diffVM.sendDifficulties()
    }
    
    func checkCeateActive() {
        if(diffVM.isCheckedEasy || diffVM.isCheckedHard){
            for subj in subVM.subjects {
                if (subj.isChecked){
                    isCreateActive = true
                    timer.upstream.connect().cancel()
                    break;
                }
            }
        }
    }
}
