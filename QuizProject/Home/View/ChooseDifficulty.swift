//
//  ChooseDifficulty.swift
//  QuizProject
//
//  Created by Martin Dinev on 14.02.22.
//

import SwiftUI

struct ChooseDifficulty: View {
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Button {
                print("ha")
            } label: {
                Text("Easy mode")
            }
            Spacer()
            Button {
                print("ha2")
            } label: {
                Text("Hard mode")
            }
            Spacer()
        }
        .frame(width: 200, height: 350, alignment: .center)
        .background(.black.opacity(0.9))
    }
}

struct ChooseDifficulty_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDifficulty()
    }
}
