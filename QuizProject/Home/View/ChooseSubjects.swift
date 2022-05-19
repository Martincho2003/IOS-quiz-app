//
//  ChooseSubjects.swift
//  QuizProject
//
//  Created by Martin Dinev on 22.02.22.
//

import SwiftUI

struct ChooseSubjects: View {
    
    @ObservedObject private var vm: SubjectViewModel
    
    init(vm: SubjectViewModel){
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            Spacer()
            ForEach(vm.subjects, id: \.self) { subject in
                HStack {
                    if subject.isChecked {
                        Text("✅")
                    } else {
                        Text("🔲")
                    }
                    Button {
                        vm.changeCheck(name: subject.name)
                    } label: {
                        Text(NSLocalizedString(subject.name.title, comment: ""))
                            .foregroundColor(.brown)
                    }
                }
            }
            Spacer()
        }
    }
}

struct ChooseSubjects_Previews: PreviewProvider {
    static var previews: some View {
        ChooseSubjects(vm: SubjectViewModel())
    }
}
