//
//  RegistrationService.swift
//  QuizProject
//
//  Created by Martin Dinev on 20.01.22.
//

import Combine
import Foundation
import Firebase

class RegistrationService{
    func register(with details: RegistrationModel) -> AnyPublisher<Void, Error> {
        Deferred{
            Future{
                promise in
                
                Auth.auth()
                    .createUser(withEmail: details.email, password: details.password) {
                        res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            if let uid = res?.user.uid {
                                Database.database()
                                    .reference()
                                    .child("users")
                                    .child(uid)
                                    .updateChildValues(["username": details.username, "points": details.points]) { error, ref in
                                        if let err = error {
                                            promise(.failure(err))
                                        } else {
                                            promise(.success(()))
                                        }
                                    }
                            } else {
                                promise(.failure(NSError(domain: "Invalid user", code: 0, userInfo: nil)))
                            }
                        }
                    }
            }
        
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
