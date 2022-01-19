//
//  HomeView.swift
//  QuizProject
//
//  Created by Martin Dinev on 19.01.22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(){
            Text("Quiz game")
                .font(.title)
            Text("Hello")//username
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}
