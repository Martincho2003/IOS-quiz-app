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
        ZStack {
            Color(UIColor(hue: 0.1056, saturation: 0.06, brightness: 0.98, alpha: 1.0)).ignoresSafeArea(.all)
            if(!vm.rooms.isEmpty){
                VStack {
                    ForEach(vm.rooms, id: \.self) { room in
                        if (room.is_game_started == "no"){
                            HStack {
                                Spacer()
                                    .frame(width: 30)
                                NavigationLink(destination: NavigationLazyView(GameRoomView(vm: GameRoomViewModel(asCreator: false, subjects: [], diffs: [], roomName: room.admin.username)))) {
                                    Text("\(room.admin.username)'s room")
                                }
                                .frame(maxWidth: .infinity, maxHeight: 45)
                                .background(.brown)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                                .cornerRadius(10)
                                Spacer()
                                    .frame(width: 30)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ChooseRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChooseRoomView()
    }
}
