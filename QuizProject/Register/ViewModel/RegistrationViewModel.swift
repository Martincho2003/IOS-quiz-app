//
//  RegistrationViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 20.01.22.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

protocol RegistrationViewModel {
    func register()
    var service: RegistrationService { get }
}

final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    var service: RegistrationService = RegistrationService()
    
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isError: Bool = false
    var eror: Error?
    
    private var subscriptions = Set<AnyCancellable>()
    
    func register() {
        service
            .register(emaill: email, pass: password, usrname: username)
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    print(error)
                    self?.eror = error
                    self?.isError.toggle()
                default: break
                }
            } receiveValue: { _ in}
            .store(in: &subscriptions)
    }
    
    func isRegistrationEnabled() -> Bool {
        if (password.isValidPassword && email.isValidEmail && username.count >= 4){
            return true
        }
        return false
    }
   
}
