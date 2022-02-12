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
    
    func isValidPassword() -> Bool {
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
    
    func isValidEmail() -> Bool{
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: email)
        }
    
    func isLoginEnabled() -> Bool{
        if (isValidPassword()){
            if (isValidEmail()){
                return true
            }
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
