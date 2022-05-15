//
//  EndGameView.swift
//  QuizProject
//
//  Created by Martin Dinev on 25.02.22.
//

import SwiftUI

struct EndGameView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State private var isHome = false
    private var points: Int
    var service: GameService = GameService()

    init(points: Int){
        self.points = points
    }
    
    var body: some View {
        VStack{
            if (isHome) {
                HomeView()
            } else {
                Spacer()
                Text("Congratulations")
                Text("You earned \(points) points")
                Spacer()
                ButtonView(title: "Go back") {
                    service.sendPoints(points)
                    isHome.toggle()
                }
            }
        }
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView(points: 2)
    }
}
