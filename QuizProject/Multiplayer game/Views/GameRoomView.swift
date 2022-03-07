//
//  GameRoomView.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import SwiftUI

struct GameRoomView: View {
    
    @ObservedObject var vm: GameRoomViewModel
    
    init(vm: GameRoomViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack{
            if(vm.room.admin.username != ""){
                Text("\(vm.room.admin.username)'s room")
                HStack {
                    Text("Subjects:")
                    ForEach(vm.room.subjects, id: \.self) { subject in
                        Text(subject)
                    }
                }
                HStack {
                    Text("Difficulties:")
                    ForEach(vm.room.difficutlies, id: \.self) { difficuty in
                        Text(difficuty)
                    }
                }
                ForEach(vm.room.users, id: \.self) { user in
                    HStack {
                        Text(user.username)
                    }
                }
            }
        }
    }
}

struct GameRoomView_Previews: PreviewProvider {
    static var previews: some View {
        GameRoomView(vm: GameRoomViewModel(asCreator: false, subjects: [], diffs: []))
    }
}
