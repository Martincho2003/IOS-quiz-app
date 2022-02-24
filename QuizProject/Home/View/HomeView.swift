//
//  HomeView.swift
//  QuizProject
//
//  Created by Martin Dinev on 19.01.22.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var vm: HomeViewModel //= HomeViewModel()
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    init(vm: HomeViewModel){
        self.vm = vm
    }
    
    var body: some View {
        if(!vm.isGame){
            if(!vm.showDifficulty){
                VStack(){
                    HStack(){
                        Spacer()
                            .frame(width: 20)
                        Text("Quiz game")
                            .font(.system(size: 35))
                        Spacer()
                        VStack(){
                            Text("\(sessionService.userDetails?.username ?? "N/A")")
                            Text("\(sessionService.userDetails?.points ?? -1) points")
                            Button(action: sessionService.logout) {
                                Text("Logout")
                            }
                        }
                        Spacer()
                            .frame(width: 20)
                    }
                    Spacer()
                    Button {
                        vm.showDifficulty.toggle()
                        print(vm.showDifficulty)
                    } label: {
                        Text("Single Player Game")
                    }
                    Button {
                    } label: {
                        Text("Multiplayer Game")
                    }
                    Spacer()
                }
            } else {
                VStack{
                    ScrollView{
                        ChooseDifficulty(vm: vm.diffVM)
                    }
                    ScrollView{
                        ChooseSubjects(vm: vm.subVM)
                    }
                    ButtonView(title: "Start game") {
                        vm.isGame.toggle()
                    }
                }
            }
        } else {
            QuestionView(vm: NormalGameViewModel(service: GameService(), subjects: vm.sendSubjects(), diffs: vm.sendDiffs()))
                .environmentObject(sessionService)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(vm: HomeViewModel())
        //HomeView(vm: HomeViewModel(sessionService: SessionServiceImpl()))
    }
}
