//
//  ChooseDifficulty.swift
//  QuizProject
//
//  Created by Martin Dinev on 14.02.22.
//

import SwiftUI

struct ChooseDifficulty: View {
    
    @ObservedObject private var vm: DifficultyViewModel
    
    init(vm: DifficultyViewModel) {
        self.vm = vm
    }
    
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
                        .foregroundColor(.brown)
                }
            }
            Spacer()
            HStack{
                if vm.isCheckedHard {
                    Text("✅")
                } else {
                    Text("🔲")
                }
                Button {
                    vm.isCheckedHard.toggle()
                } label: {
                    Text("Hard mode")
                        .foregroundColor(.brown)
                }
            }
        }
    }
}

struct ChooseDifficulty_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDifficulty(vm:  DifficultyViewModel())
    }
}
