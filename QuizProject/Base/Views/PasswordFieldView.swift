//
//  PasswordFieldView.swift
//  QuizProject
//
//  Created by Martin Dinev on 10.01.22.
//

import SwiftUI

struct PasswordFieldView: View {
    @Binding var text: String
    let placeholder: String
    let symbol: String?
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .frame(maxWidth: .infinity, minHeight: 35, maxHeight: 45)
            .padding(.leading, symbol == nil ? 15 : 30)
            .background(
                ZStack(alignment: .leading){
                    if let systemImage = symbol {
                        Image(systemName: systemImage)
                            .font(.system(size: 18))
                            .padding(.leading, 5)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.gray.opacity(0.45))
                }
            )
    }
}

struct PasswordFieldView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordFieldView(text: .constant(""), placeholder: "Password", symbol: "lock")
    }
}
