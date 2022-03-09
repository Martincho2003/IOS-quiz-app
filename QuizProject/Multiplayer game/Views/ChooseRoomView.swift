//
//  ChooseRoom.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import SwiftUI

struct ChooseRoomView: View {
    
    @ObservedObject var vm = ChooseRoomViewModel()
    
    var body: some View {
        if(!vm.rooms.isEmpty){
            ForEach(vm.rooms, id: \.self) { room in
                NavigationLink("\(room.admin.username)'s room", destination: GameRoomView(vm: GameRoomViewModel(asCreator: false, subjects: [], diffs: [], roomName: room.admin.username)))
            }
        }
    }
}

struct ChooseRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChooseRoomView()
    }
}
