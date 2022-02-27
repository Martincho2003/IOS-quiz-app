//
//  EndGameView.swift
//  QuizProject
//
//  Created by Martin Dinev on 25.02.22.
//

import SwiftUI

struct EndGameView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        HStack{
            Spacer()
            Text("Congratulations")
            Text("You earned \(4) points")
            Spacer()
            NavigationLink(destination: HomeView().environmentObject(sessionService)) {
                Text("Go back")
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView()
    }
}
