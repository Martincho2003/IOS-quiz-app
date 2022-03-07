//
//  SubjectViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 23.02.22.
//

import Foundation

struct SubjectCheck: Hashable {
    var name: Subject
    var isChecked: Bool = false
}


final class SubjectViewModel: ObservableObject {
    @Published var subjects: [SubjectCheck] = []
    
    init(){
        Subject.allCases.forEach { subject in
            subjects.append(SubjectCheck(name: subject))
        }
    }
    
    func changeCheck(name: Subject){
        for i in 0..<subjects.count {
            if(subjects[i].name.title == name.title) {
                subjects[i].isChecked.toggle()
                break;
            }
        }
    }
    
    func refreshBooleans() {
        for i in 0..<subjects.count {
            subjects[i].isChecked = false
        }
    }
    
    func sendSubjects() -> [Subject]{
        var newSubjects: [Subject] = []
        for subject in subjects {
            if (subject.isChecked){
                newSubjects.append(subject.name)
            }
        }
        print(newSubjects)
        return newSubjects
    }
    
    func isCreateDisabled() -> Bool {
        for subject in subjects {
            if (subject.isChecked == true){
                return false
            }
        }
        return true
    }
}
