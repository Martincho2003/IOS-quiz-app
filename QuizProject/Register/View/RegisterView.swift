//
//  RegisterView.swift
//  QuizProject
//
//  Created by Martin Dinev on 17.01.22.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var vm = RegistrationViewModelImpl()
    
    var body: some View {
        NavigationView{
            VStack(spacing: 16) {
                
                Spacer()
                    .frame(height: 30)
                
                Text("Register")
                    .font(.system(size: 40, weight: .bold))
                
                Spacer()
                
                InputTextField(text: $vm.email, placeholder: "Email", keyboardType: .emailAddress, symbol: "envelope")
                    .autocapitalization(.none)
                
                InputTextField(text: $vm.username, placeholder: "Username", keyboardType: .default, symbol: nil)
                
                PasswordFieldView(text: $vm.password, placeholder: "Password", symbol: "lock")
                
                ButtonView(title: "Register") {
                    vm.register()
                }
                .disabled(!vm.isRegistrationEnabled())
                .alert(isPresented: $vm.isError) {
                    Alert(
                        title: Text("Error"),
                        message: Text(vm.eror?.localizedDescription ?? "No error")
                    )
                }
                VStack {
                    Spacer()
                    FacebookLoginView().frame(width: 180, height: 28).padding(15)
                    
                    AppleLoginView()
                }
                    
                Spacer()
                    .frame(height: 100)
            }
            .padding(.horizontal, 15)
            .toolbar {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
        }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
