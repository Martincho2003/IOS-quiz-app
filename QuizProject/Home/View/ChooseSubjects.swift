//
//  ChooseSubjects.swift
//  QuizProject
//
//  Created by Martin Dinev on 22.02.22.
//

import SwiftUI

struct ChooseSubjects: View {
    
    @ObservedObject private var vm = SubjectViewModel()
    
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
                        Text(subject.name.title)
                    }
                }
            }
            Spacer()
            ButtonView(title: "Continue") {
                vm.sendSubjects()
            }
            Spacer()
                .frame(height: 20)
        }
    }
}

struct ChooseSubjects_Previews: PreviewProvider {
    static var previews: some View {
        ChooseSubjects()
    }
}
