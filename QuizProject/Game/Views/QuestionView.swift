//
//  QuestionView.swift
//  QuizProject
//
//  Created by Martin Dinev on 18.02.22.
//

import SwiftUI

struct QuestionView: View {
    
    @ObservedObject private var vm: NormalGameViewModel
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    init(vm: NormalGameViewModel){
        self.vm = vm
    }
    
    var body: some View {
        VStack{
            if(vm.currentQuestion == vm.questions.count){
                EndGameView(points: vm.points).environmentObject(sessionService)
            }else{
                if(!vm.questions.isEmpty){
                    Text("\(vm.seconds[vm.currentQuestion])")
                        .onReceive(vm.timer) { _ in
                            vm.seconds[vm.currentQuestion] -= 1
                            vm.checkSeconds()
                        }
                    
                    Spacer()
                
                    Text(vm.questions[vm.currentQuestion].question)
                    
                    Spacer()
                    
                    ForEach(vm.questions[vm.currentQuestion].answers, id: \.self) { answer in
                        HStack{
                            Spacer()
                                .frame(width: 30)
                            ButtonView(title: answer.answer) {
                                vm.checkAnswer(answer)
                            }
                            Spacer()
                                .frame(width: 30)
                        }
                    }
                    
                    Spacer()
    
                    HStack{
                        Button {
                            vm.addTime()
                        } label: {
                            VStack{
                                Text("+20 sec")
                                if (vm.questions[vm.currentQuestion].difficulty == .hard) {
                                Text("-2 points")
                                } else {
                                    Text("-1 point")
                                }
                            }
                        }
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.white)
                            .background(Circle().fill(.brown))
                            .disabled(vm.isAddTimeDeactivated())
                        
                        Spacer()
                        
                        Button {
                            vm.excludeAnswers()
                        } label: {
                            VStack{
                                Text("50/50")
                                if (vm.questions[vm.currentQuestion].difficulty == .hard) {
                                Text("-4 points")
                                } else {
                                    Text("-2 points")
                                }
                            }
                        }
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.white)
                            .background(Circle().fill(.brown))
                            .disabled(vm.isExcludeDeactivated())
                    }
                }
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(vm: NormalGameViewModel(sessionService: SessionServiceImpl(), subjects: [.biology], diffs: [.hard]))
    }
}
