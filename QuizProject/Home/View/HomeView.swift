//
//  HomeView.swift
//  QuizProject
//
//  Created by Martin Dinev on 19.01.22.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var vm: HomeViewModel  = HomeViewModel()
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
//    init(vm: HomeViewModel){
//        self.vm = vm
//    }
    
    var body: some View {
        ZStack(){
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
                ButtonView(title: "Game", background: .white, foreground: .blue, border: .blue) { vm.isGame.toggle()
                }
                .sheet(isPresented: $vm.isGame) {
                    QuestionView()
                }
                Spacer()

            }
            if vm.showDifficulty {
                GeometryReader{ geometry in
                    ChooseDifficulty()
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                }
                .background(
                        Color.black.opacity(0.65)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                vm.showDifficulty.toggle()
                            }
                )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        //HomeView(vm: HomeViewModel(sessionService: SessionServiceImpl()))
    }
}
