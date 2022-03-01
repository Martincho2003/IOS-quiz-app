//
//  LeaderboardView.swift
//  QuizProject
//
//  Created by Martin Dinev on 27.02.22.
//

import SwiftUI

struct LeaderboardView: View {
    
    private var users: [SessionUserDetails]
    
    init(users: [SessionUserDetails]){
        self.users = users
    }
    
    var body: some View {
        if(!users.isEmpty){
            ScrollView{
                ForEach(users, id: \.self) { user in
                    HStack {
                        Text(user.username)
                        Text("\(user.points)")
                    }
                }
            }
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(users: [])
    }
}
