//
//  AppleLoginViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 2.03.22.
//

import Foundation
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import FirebaseDatabase
import Combine

class AppleLoginViewModel: ObservableObject {
    
    @Published var nonce = ""
    private var subscriptions = Set<AnyCancellable>()
    private var isUsr = false
    
    func authenticate(credential: ASAuthorizationAppleIDCredential){
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { [self] (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            RegistrationService().isUserExist(uid: result?.user.uid ?? "")
                .sink { [self] res in
                    switch res {
                    case .finished:
                        if (!isUsr) {
                            let format = DateFormatter()
                            format.dateFormat = "MM-dd-yyyy"
                            Database.database()
                                .reference()
                                .child("users")
                                .child(result?.user.uid ?? "")
                                .updateChildValues(["username": result?.user.displayName ?? "unknown",
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
    
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
    return result
    }
    
}
