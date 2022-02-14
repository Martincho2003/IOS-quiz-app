//
//  CredentialsCheck.swift
//  QuizProject
//
//  Created by Martin Dinev on 14.02.22.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: email)
}

func isValidPassword(_ password: String) -> Bool {
    let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
    let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
    return passwordCheck.evaluate(with: password)

}
