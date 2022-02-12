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

enum RegistrationState {
    case successfull
    case failed(error: Error)
    case na
}

protocol RegistrationViewModel {
    func register()
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    init(service: RegistrationService)
}

final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    var service: RegistrationService
    
    var state: RegistrationState = .na
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isError: Bool = false
    var eror: Error?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RegistrationService) {
        self.service = service
    }
    
    func register() {
        service
            .register(emaill: email, pass: password, usrname: username)
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                    self?.eror = error
                    self?.isError.toggle()
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
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
    
    func isRegistrationEnabled() -> Bool {
        print("hah0")
        if (isValidPassword()){
            if (isValidEmail()){
                if (username.count >= 4){
                    return true
                }
            }
        }
        return false
    }
   
}
