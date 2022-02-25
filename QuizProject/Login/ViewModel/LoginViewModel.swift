//
//  LoginViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 12.02.22.
//

import Foundation
import Combine

enum LoginState {
    case successfull
    case failed(error: Error)
    case na
}

protocol LoginViewModel {
    func login()
    var state: LoginState { get }
    var service: LoginSerivce { get }
    init(service: LoginSerivce)
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    
    var service: LoginSerivce
    
    @Published var state: LoginState = .na
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isError: Bool = false
    var eror: Error?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: LoginSerivce) {
        self.service = service
    }
    
    
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
                    self.state = .failed(error: err)
                    self.eror = err
                    self.isError.toggle()
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
    }
}
