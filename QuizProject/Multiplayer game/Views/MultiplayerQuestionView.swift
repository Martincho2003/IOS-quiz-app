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
            if(vm.currentQuestion == $vm.room.questions.count){
                MultiplayerEndView(vm: MultiplayerEndVM(users: []))
            }else{
                if(!$vm.room.questions.isEmpty){
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
                                Text("-2 points")
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
                                Text("-4 points")
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
