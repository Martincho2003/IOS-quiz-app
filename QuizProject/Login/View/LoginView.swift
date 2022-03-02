//
//  LoginView.swift
//  QuizProject
//
//  Created by Martin Dinev on 9.01.22.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @State private var isRegister: Bool = false
    
    @StateObject private var vm = LoginViewModelImpl(service: LoginSerivce())

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 30)
            Text("Login")
                .font(.system(size: 40, weight: .bold))
            Spacer()
            InputTextField(text: $vm.email, placeholder: "Email", keyboardType: .emailAddress, symbol: "envelope")
                .autocapitalization(.none)
            PasswordFieldView(text: $vm.password, placeholder: "Password", symbol: "lock")
            ButtonView(title: "Login") {
                vm.login()
            }
            .disabled(!vm.isLoginEnabled())
            .alert(isPresented: $vm.isError) {
                Alert(
                    title: Text("Error"),
                    message: Text(vm.eror?.localizedDescription ?? "No error")
                )
            }
            ButtonView(title: "Register", background: .white, foreground: .blue, border: .blue) { isRegister.toggle()
            }
            .sheet(isPresented: $isRegister) {
                RegisterView()
            }
            Spacer()
                .frame(height: 30)
            VStack{
                Spacer()
                FacebookLoginView().frame(width: 180, height: 28).padding(15)
                
                AppleLoginView()
                Spacer()
            }
        }
        .padding(.horizontal, 15)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
