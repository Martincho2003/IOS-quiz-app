//
//  LoginView.swift
//  QuizProject
//
//  Created by Martin Dinev on 9.01.22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var isRegister: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 30)
            Text("Login")
                .font(.system(size: 40, weight: .bold))
            Spacer()
            InputTextField(text: .constant(""), placeholder: "Email", keyboardType: .emailAddress, symbol: "envelope")
            PasswordFieldView(text: .constant(""), placeholder: "Password", symbol: "lock")
            ButtonView(title: "Login") { }
            ButtonView(title: "Register", background: .white, foreground: .blue, border: .blue) { isRegister.toggle()
            }
            .sheet(isPresented: $isRegister) {
                RegisterView()
            }
            Spacer()
                .frame(height: 100)
        }
        .padding(.horizontal, 15)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
