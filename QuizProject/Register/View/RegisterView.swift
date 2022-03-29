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
                
                InputTextField(text: $vm.email, placeholder: NSLocalizedString("Email", comment: ""), keyboardType: .emailAddress, symbol: "envelope")
                    .autocapitalization(.none)
                
                InputTextField(text: $vm.username, placeholder: NSLocalizedString("Username", comment: ""), keyboardType: .default, symbol: nil)
                
                PasswordFieldView(text: $vm.password, placeholder: NSLocalizedString("Password", comment: ""), symbol: "lock")
                
                ButtonView(title: NSLocalizedString("Register", comment: "")) {
                    vm.register()
                }
                .disabled(!vm.isRegistrationEnabled())
                .alert(isPresented: $vm.isError) {
                    Alert(
                        title: Text("Error"),
                        message: Text(vm.eror?.localizedDescription ?? "No error")
                    )
                }
                Spacer()
                FacebookLoginView().frame(width: 180, height: 28).padding(15)
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
