//
//  MultiplayerQuestionView.swift
//  QuizProject
//
//  Created by Martin Dinev on 10.03.22.
//

import SwiftUI

struct MultiplayerQuestionView: View {
    
    @ObservedObject var vm: MultiplayerQuestionVM
    
    init(vm: MultiplayerQuestionVM) {
        self.vm = vm
    }
    
    var body: some View {
        VStack{
            if(vm.user.isFinished == "yes"){
                MultiplayerEndView(vm: MultiplayerEndVM(room: vm.room))
            }else{
                if(!$vm.room.questions.isEmpty && vm.user.isFinished == "no" && vm.currentQuestion < vm.room.questions.count){
                    Text("\(vm.seconds[vm.currentQuestion])")
                        .onReceive(vm.timer) { _ in
                            vm.seconds[vm.currentQuestion] -= 1
                            vm.checkSeconds()
                        }
                    
                    Spacer()
                
                    Text(vm.room.questions[vm.currentQuestion].question)
                    
                    Spacer()
                    
                    ForEach(vm.room.questions[vm.currentQuestion].answers, id: \.self) { answer in
                        Button {
                            print(vm.checkAnswer(answer))
                        } label: {
                            Text(answer.answer)
                        }
                    }
                    
                    Spacer()
    
                    HStack{
                        Button {
                            vm.addTime()
                        } label: {
                            VStack{
                                Text("+20 sec")
                                if (vm.room.questions[vm.currentQuestion].difficulty == .hard) {
                                Text("-2 points")
                                } else {
                                    Text("-1 point")
                                }
                            }
                        }
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.white)
                            .background(Circle().fill(.blue))
                            .disabled(vm.isAddTimeDeactivated())
                        
                        Spacer()
                        
                        Button {
                            vm.excludeAnswers()
                        } label: {
                            VStack{
                                Text("50/50")
                                if (vm.room.questions[vm.currentQuestion].difficulty == .hard) {
                                Text("-4 points")
                                } else {
                                    Text("-2 points")
                                }
                            }
                        }
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.white)
                            .background(Circle().fill(.blue))
                            .disabled(vm.isExcludeDeactivated())
                    }
                }
            }
        }
    }
}
