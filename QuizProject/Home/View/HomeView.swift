//
//  HomeView.swift
//  QuizProject
//
//  Created by Martin Dinev on 19.01.22.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var vm: HomeViewModel = HomeViewModel()    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        if(!vm.isGame){
            if(!vm.showGameMode){
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
                            if (sessionService.getUserProvider() == "facebook.com"){
                                FacebookLoginView().frame(width: 10, height: 8)
                                    
                            } else {
                                Button(action: sessionService.logout) {
                                    Text("Logout")
                                }
                            }
                        }
                        Spacer()
                            .frame(width: 20)
                    }
                    Spacer()
                        .frame(height: 50)
                    LeaderboardView(users: vm.topUsers)
                        .frame(height: 200)
                        .border(.blue)
                    Spacer()
                        .frame(height: 150)
                    Button {
                        vm.showGameMode.toggle()
                        print(vm.showGameMode)
                    } label: {
                        Text("Single Player Game")
                    }
                    Spacer()
                        .frame(height: 50)
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
            QuestionView(vm: NormalGameViewModel(service: GameService(), sessionService: sessionService, subjects: vm.sendSubjects(), diffs: vm.sendDiffs()))
                .environmentObject(sessionService)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(SessionServiceImpl())
        //HomeView(vm: HomeViewModel(sessionService: SessionServiceImpl()))
    }
}
