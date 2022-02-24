//
//  QuestionView.swift
//  QuizProject
//
//  Created by Martin Dinev on 18.02.22.
//

import SwiftUI

struct QuestionView: View {
    
    @ObservedObject private var vm: NormalGameViewModel //= NormalGameViewModel(service: GameService())
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    init(vm: NormalGameViewModel){
        self.vm = vm
    }
    
    var body: some View {
        VStack{
            Text("Seconds")
            if(sessionService.state == .loggedIn){
                Text("logged")
            }
            Spacer()
            
            if (!vm.questions.isEmpty){
                Text(vm.questions[vm.currentQuestion].question)
                Spacer()
                ForEach(vm.questions[vm.currentQuestion].answers, id: \.self) { answer in
                    Button {
                        print(vm.checkAnswer(answer))
                    } label: {
                        Text(answer.answer)
                    }
                }
            }
            Spacer()
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(vm: NormalGameViewModel(service: GameService(), subjects: [.biology], diffs: [.hard]))
    }
}
