//
//  LoginViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 12.02.22.
//

import Foundation
import Combine

protocol LoginViewModel {
    func login()
    var service: LoginSerivce { get }
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    
    var service: LoginSerivce = LoginSerivce()
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isError: Bool = false
    var eror: Error?
    
    private var subscriptions = Set<AnyCancellable>()
    
    func isLoginEnabled() -> Bool{
        if (password.isValidPassword && email.isValidEmail){
            return true
        }
        return false
    }
    
    func login() {
        service
            .login(emaill: email, pass: password)
            .sink { res in
                
                switch res {
                case .failure(let err):
                    self.eror = err
                    self.isError.toggle()
                default: break
                }
            } receiveValue: { _ in}
            .store(in: &subscriptions)
    }
}
