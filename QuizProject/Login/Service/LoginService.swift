//
//  LoginService.swift
//  QuizProject
//
//  Created by Martin Dinev on 12.02.22.
//

import Foundation
import Combine
import FirebaseAuth

final class LoginSerivce {
    
    func login(emaill: String, pass: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future {
                promise in
                
                Auth
                    .auth()
                    .signIn(withEmail: emaill, password: pass) { res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
