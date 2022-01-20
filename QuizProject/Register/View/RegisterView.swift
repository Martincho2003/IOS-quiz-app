//
//  RegisterView.swift
//  QuizProject
//
//  Created by Martin Dinev on 17.01.22.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var vm = RegistrationViewModelImpl(service: RegistrationService())
    
    var body: some View {
        VStack(spacing: 16) {
            
            Spacer()
                .frame(height: 30)
            
            Text("Register")
                .font(.system(size: 40, weight: .bold))
            
            Spacer()
            
            InputTextField(text: $vm.userDetails.email, placeholder: "Email", keyboardType: .emailAddress, symbol: "envelope")
            
            InputTextField(text: $vm.userDetails.username, placeholder: "Username", keyboardType: .default, symbol: nil)
            
            PasswordFieldView(text: $vm.userDetails.password, placeholder: "Password", symbol: "lock")
            
            ButtonView(title: "Register") {
                vm.register()
            }
                
            Spacer()
                .frame(height: 100)
        }
        .padding(.horizontal, 15)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
