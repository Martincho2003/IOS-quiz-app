//
//  FacebookLoginView.swift
//  QuizProject
//
//  Created by Martin Dinev on 1.03.22.
//

import SwiftUI
import FBSDKLoginKit
import Firebase
import Combine

struct FacebookLoginView: UIViewRepresentable {
    
    func makeCoordinator() -> FacebookLoginView.Coordinator {
        return FacebookLoginView.Coordinator()
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        
        private var isUsr: Bool = false
        private var subscriptions = Set<AnyCancellable>()
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if let error = error {
              print(error.localizedDescription)
              return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
            Auth.auth().signIn(with: credential) { [self] (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                RegistrationService().isUserExist(uid: authResult?.user.uid ?? "")
                    .sink { [self] res in
                        switch res {
                        case .finished:
                            if (!isUsr) {
                                let format = DateFormatter()
                                format.dateFormat = "MM-dd-yyyy"
                                Database.database()
                                    .reference()
                                    .child("users")
                                    .child(authResult?.user.uid ?? "")
                                    .updateChildValues(["username": authResult?.user.displayName ?? "unknown",
                                                        "points": 0,
                                                        "last_day_played" : format.string(from: Date()),
                                                        "played_games": 0])
                            }
                        default: break
                        }
                    } receiveValue: { [self] isUser in
                        isUsr = isUser
                    }
                    .store(in: &subscriptions)
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<FacebookLoginView>) -> FBLoginButton {
        let view = FBLoginButton()
        view.permissions = ["email", "public_profile"]
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<FacebookLoginView>) { }
}

struct FacebookLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FacebookLoginView()
    }
}
