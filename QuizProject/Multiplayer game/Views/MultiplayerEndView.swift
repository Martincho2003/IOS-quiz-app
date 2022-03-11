//
//  MultiplayerEndView.swift
//  QuizProject
//
//  Created by Martin Dinev on 10.03.22.
//

import SwiftUI

struct MultiplayerEndView: View {
    
    @ObservedObject var vm: MultiplayerEndVM
    
    init(vm: MultiplayerEndVM) {
        self.vm = vm
    }
    
    var body: some View {
        HStack {
            ForEach(vm.users, id: \.self) { user in
                Text("\(user.username): \(user.gamePoints)")
            }
        }
    }
}

struct MultiplayerEndView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerEndView(vm: MultiplayerEndVM(room: Room(admin: SessionUserDetails(username: "", points: -1, last_day_played: "", played_games: -1), subjects: [], difficutlies: [], users: [], questions: [], is_game_started: "")))
    }
}
