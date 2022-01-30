//
//  RegistrationViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 20.01.22.
//

import Foundation
import Combine

enum RegistrationState {
    case successfull
    case failed(error: Error)
    case na
}

protocol RegistrationViewModel {
    func register()
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    var userDetails: RegistrationModel { get }
    init(service: RegistrationService)
}

final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    
    var service: RegistrationService
    
    init(service: RegistrationService) {
        self.service = service
    }
    
    var state: RegistrationState = .na
    
    var userDetails: RegistrationModel = RegistrationModel(email: "", username: "", points: 0, password: "")
    
    private var subsicriptions = Set<AnyCancellable>()
    
    func register() {
        print(userDetails)
        service
            .register(with: userDetails)
            .sink { [weak self] res in
                
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subsicriptions)
    }
}
