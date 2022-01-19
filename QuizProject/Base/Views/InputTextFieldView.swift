//
//  InputTextField.swift
//  QuizProject
//
//  Created by Martin Dinev on 9.01.22.
//

import SwiftUI

struct InputTextField: View {
    
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let symbol: String?
    
    var body: some View {
        TextField(placeholder, text: $text)
            .frame(maxWidth: .infinity, minHeight: 35, maxHeight: 45)
            .padding(.leading, symbol == nil ? 15 : 30)
            .keyboardType(keyboardType)
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

struct InputTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InputTextField(text: .constant(""), placeholder: "Email", keyboardType: .emailAddress, symbol: "envelope")
                .previewInterfaceOrientation(.portrait)
                .padding()
            
            InputTextField(text: .constant(""), placeholder: "Name", keyboardType: .default, symbol: nil)
                .previewInterfaceOrientation(.portrait)
                .padding()
        }
    }
}
