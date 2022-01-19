//
//  RegisterView.swift
//  QuizProject
//
//  Created by Martin Dinev on 17.01.22.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 30)
            Text("Register")
                .font(.system(size: 40, weight: .bold))
            Spacer()
            InputTextField(text: .constant(""), placeholder: "Email", keyboardType: .emailAddress, symbol: "envelope")
            InputTextField(text: .constant(""), placeholder: "Username", keyboardType: .default, symbol: nil)
            PasswordFieldView(text: .constant(""), placeholder: "Password", symbol: "lock")
            ButtonView(title: "Register") { }
            
        .padding(.horizontal, 15)
            Spacer()
                .frame(height: 100)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
