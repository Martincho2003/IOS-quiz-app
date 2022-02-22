//
//  NextQuestionView.swift
//  QuizProject
//
//  Created by Martin Dinev on 22.02.22.
//

import SwiftUI

struct NextQuestionView: View {
    var vm: NormalGameViewModel
    var questionNum: Int
    @State private var nextQuestion = false
    
    init(vm: NormalGameViewModel, questionNum: Int){
        self.vm = vm
        self.questionNum = questionNum
    }
    
    var body: some View {
        VStack{
            Text("Seconds")
            Spacer()
            if (!vm.questions.isEmpty){
                Text(vm.questions[questionNum].question)
                Spacer()
                ForEach(vm.questions[questionNum].answers, id: \.self) { answer in
                    Button {
                        nextQuestion.toggle()
                        print(vm.checkAnswer(answer))
                    } label: {
                        Text(answer.answer)
                    }
                }
            }
//
            Spacer()
        }
        .navigate(to: NextQuestionView(vm: vm ,questionNum: questionNum+1), when: $nextQuestion)
    }
}

struct NextQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        NextQuestionView(vm: NormalGameViewModel(service: GameService()), questionNum: 0)
    }
}
