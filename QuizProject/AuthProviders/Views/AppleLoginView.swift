//
//  AppleLoginView.swift
//  QuizProject
//
//  Created by Martin Dinev on 2.03.22.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    
    @StateObject var vm = AppleLoginViewModel()
    
    var body: some View {
        SignInWithAppleButton { request in
            vm.nonce = vm.randomNonceString()
            request.requestedScopes = [.email, .fullName]
            request.nonce = vm.sha256(vm.nonce)
        } onCompletion: { result in
            switch result {
            case .success(let user):
                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                    print("error with firebase")
                    return;
                }
                vm.authenticate(credential: credential)
                print(user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .signInWithAppleButtonStyle(.white)
        .frame(width: 200, height: 40)
        .padding(15)
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}
