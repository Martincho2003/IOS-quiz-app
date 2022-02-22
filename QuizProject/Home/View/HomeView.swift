//
//  HomeView.swift
//  QuizProject
//
//  Created by Martin Dinev on 19.01.22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State private var showDifficulty: Bool = false
    
    @State private var isGame: Bool = false
    
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
                    showDifficulty.toggle()
                    print(showDifficulty)
                } label: {
                    Text("Normal Game")
                }
                ButtonView(title: "Game", background: .white, foreground: .blue, border: .blue) { isGame.toggle()
                }
                .sheet(isPresented: $isGame) {
                    QuestionView()
                }
                Spacer()

            }
            if self.showDifficulty {
                GeometryReader{ geometry in
                    ChooseDifficulty()
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                }
                .background(
                        Color.black.opacity(0.65)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                self.showDifficulty.toggle()
                            }
                )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SessionServiceImpl())
    }
}
