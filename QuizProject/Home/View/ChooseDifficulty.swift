//
//  ChooseDifficulty.swift
//  QuizProject
//
//  Created by Martin Dinev on 14.02.22.
//

import SwiftUI

struct ChooseDifficulty: View {
    
    @ObservedObject private var vm = DifficultyViewModel()
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            HStack{
                if vm.isCheckedEasy {
                    Text("✅")
                } else {
                    Text("🔲")
                }
                Button {
                    vm.isCheckedEasy.toggle()
                } label: {
                    Text("Easy mode")
                }
            }
            Spacer()
            HStack{
                if vm.isCheckdHard {
                    Text("✅")
                } else {
                    Text("🔲")
                }
                Button {
                    vm.isCheckdHard.toggle()
                } label: {
                    Text("Hard mode")
                }
            }
            Spacer()
            ButtonView(title: "Continue") {
                vm.sendDifficulties()
            }
            Spacer()
                .frame(height: 20)

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
