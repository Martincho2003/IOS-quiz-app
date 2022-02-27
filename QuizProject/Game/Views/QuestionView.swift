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
            if(vm.currentQuestion == 10){
                EndGameView().environmentObject(sessionService)
            }else{
                if(!vm.questions.isEmpty){
                    Text("\(vm.seconds[vm.currentQuestion])")
                        .onReceive(vm.timer) { _ in
                            vm.seconds[vm.currentQuestion] -= 1
                            print(vm.questions.count)
                            print(vm.seconds.count)
                            print(vm.isAddTime.count)
                            print(vm.isExclude.count)
                            print("\n")
                            vm.checkSeconds()
                        }
                    
                    Spacer()
                
                    Text(vm.questions[vm.currentQuestion].question)
                    
                    Spacer()
                    
                    ForEach(vm.questions[vm.currentQuestion].answers, id: \.self) { answer in
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
                            .disabled(vm.isAddTime[vm.currentQuestion])
                        
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
                            .disabled(vm.isExclude[vm.currentQuestion])
                    }
                }
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(vm: NormalGameViewModel(service: GameService(), subjects: [.biology], diffs: [.hard]))
    }
}
