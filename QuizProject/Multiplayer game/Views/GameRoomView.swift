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
        ZStack {
            Color(UIColor(hue: 0.1056, saturation: 0.06, brightness: 0.98, alpha: 1.0)).ignoresSafeArea(.all)
            VStack{
                if(vm.room.is_game_started == "no"){
                    if(vm.room.admin.username != ""){
                        Text("\(vm.room.admin.username)'s room")
                            .font(.title)
                        Spacer()
                        HStack {
                            Text("Subjects:")
                            ForEach(vm.room.subjects, id: \.self) { subject in
                                Text(NSLocalizedString(subject, comment: ""))
                            }
                        }
                        Spacer()
                            .frame(height: 20)
                        HStack {
                            Text("Difficulties:")
                            ForEach(vm.room.difficutlies, id: \.self) { difficuty in
                                Text(NSLocalizedString(difficuty, comment: ""))
                            }
                        }
                        Spacer()
                            .frame(height: 50)
                        ForEach(vm.room.users, id: \.self) { user in
                            HStack {
                                Text(user.username)
                            }
                        }
                        Spacer()
                        if (vm.asCreator) {
                            ButtonView(title: NSLocalizedString("Start game", comment: "")) {
                                vm.startGame()
                            }
                            .disabled(vm.isStartDisabled())
                        }
                        Spacer()
                            .frame(height: 20)
                    }
                } else {
                    MultiplayerQuestionView(vm: MultiplayerQuestionVM(room: vm.room))
                }
            }
        }
    }
}

struct GameRoomView_Previews: PreviewProvider {
    static var previews: some View {
        GameRoomView(vm: GameRoomViewModel(asCreator: false, subjects: [], diffs: [], roomName: ""))
    }
}
