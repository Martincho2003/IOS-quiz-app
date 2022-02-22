//
//  QuestionView.swift
//  QuizProject
//
//  Created by Martin Dinev on 18.02.22.
//

import SwiftUI

struct QuestionView: View {
    
    @StateObject private var vm = NormalGameViewModel(service: GameService())
    
    var body: some View {
        VStack{
            Text("Seconds")
            Spacer()
            
            if (!vm.questions.isEmpty){
                Text(vm.questions[vm.currecntQuestion].question)
                Spacer()
                ForEach(vm.questions[vm.currecntQuestion].answers, id: \.self) { answer in
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
        QuestionView()
    }
}
