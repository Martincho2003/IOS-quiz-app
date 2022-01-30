//
//  HomeView.swift
//  QuizProject
//
//  Created by Martin Dinev on 19.01.22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        VStack(){
            Text("Quiz game")
                .font(.title)
            Text("Hello \(sessionService.userDetails?.username ?? "N/A")")
            Text("You have \(sessionService.userDetails?.points ?? -1)")
            ButtonView(title: "Logout") {
                sessionService.logout()
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
