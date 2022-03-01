//
//  HomeViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 23.02.22.
//

import Foundation
import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    @Published var topUsers: [SessionUserDetails] = []
    var subscriptions = Set<AnyCancellable>()
    @Published var showGameMode: Bool = false
    @Published var isGame: Bool = false
    @Published var diffVM: DifficultyViewModel = DifficultyViewModel()
    @Published var subVM: SubjectViewModel = SubjectViewModel()
    var service = LeaderboardService()

    init(){
        service.getTop10Players()
            .sink { res in
                switch res {
                case .failure(_):
                    print(res)
                default: break
                }
            } receiveValue: { [self] users in
                topUsers.append(contentsOf: users)
            }
            .store(in: &subscriptions)
    }
    
    func sendSubjects() -> [Subject] {
        subVM.sendSubjects()
    }
    
    func sendDiffs() -> [Difficulty] {
        diffVM.sendDifficulties()
    }
    
}
