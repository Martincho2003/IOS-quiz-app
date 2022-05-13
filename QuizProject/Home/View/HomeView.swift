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
                                Button {
                                    sessionService.logout()
                                } label: {
                                    Text("Logout")
                                        .foregroundColor(.brown)
                                        .font(Font.body.bold())
                                }

                            }
                        }
                        Spacer()
                            .frame(width: 20)
                    }
                    Spacer()
                        .frame(height: 50)
                    LeaderboardView(users: vm.topUsers)
                    Spacer()
                        .frame(height: 150)
//                    Button {
//                        vm.showGameMode.toggle()
//                        print(vm.showGameMode)
//                    } label: {
//                        Text("Single Player Game")
//                    }
                    
                    HStack {
                        Spacer()
                            .frame(width: 30)
                        ButtonView(title: "Single Player Game") {
                            vm.showGameMode.toggle()
                        }
                        Spacer()
                            .frame(width: 30)
                    }
                    Spacer()
                        .frame(height: 50)
                    HStack {
                        Spacer()
                            .frame(width: 30)
                        NavigationLink("Multiplayer Game", destination: MultiplayerHomeView())
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(.brown)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                            .cornerRadius(10)
                            
                        Spacer()
                            .frame(width: 30)
                    }
                    Spacer()
                }
            } else {
                VStack{
                    HStack{
                        Button {
                            vm.showGameMode.toggle()
                        } label: {
                            Text("< Back")
                                .foregroundColor(.brown)
                        }
                        Spacer()
                    }
                    ScrollView{
                        ChooseDifficulty(vm: vm.diffVM)
                    }
                    ScrollView{
                        ChooseSubjects(vm: vm.subVM)
                    }
                    HStack{
                        Spacer()
                            .frame(width: 30)
                        ButtonView(title: "Start game") {
                            vm.isGame.toggle()
                        }
                        Spacer()
                            .frame(width: 30)
                    }
                }
            }
        } else {
            QuestionView(vm: NormalGameViewModel(sessionService: sessionService, subjects: vm.sendSubjects(), diffs: vm.sendDiffs()))
                .environmentObject(sessionService)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(SessionServiceImpl())
            .environment(\.locale, .init(identifier: "en"))
    }
}
