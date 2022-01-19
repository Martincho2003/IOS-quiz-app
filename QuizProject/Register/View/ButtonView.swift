//
//  ButtonView.swift
//  QuizProject
//
//  Created by Martin Dinev on 17.01.22.
//

import SwiftUI

struct ButtonView: View {
    
    
    let title: String
    let background: Color
    let foreground: Color
    let border: Color
    let handler: () -> Void
    
    internal init(title: String,
                  background: Color = .blue,
                  foreground: Color = .white,
                  border: Color = .clear,
                  handler: @escaping () -> Void) {
            self.title = title
            self.background = background
            self.foreground = foreground
            self.border = border
            self.handler = handler
        }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 35, maxHeight: 45)
        })
            .background(background)
            .foregroundColor(foreground)
            .font(.system(size: 16, weight: .bold))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(border, lineWidth: 2)
            )
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "Login", background: .white, foreground: .blue, border: .blue) { }
    }
}
