//
//  GameRoomView.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import SwiftUI

struct MultiplayerHomeView: View {
    
    @StateObject var vm: MultiplayerHomeVM = MultiplayerHomeVM()
    
//    init(vm: MultiplayerHomeVM) {
//        self.vm = vm
//    }
    
    var body: some View {
        VStack{
            if (!vm.showGameDetails){
                Button {
                    vm.showGameDetails.toggle()
                } label: {
                    Text("Create Room")
                }
                NavigationLink("Join Room", destination: ChooseRoomView())
                    .simultaneousGesture(TapGesture().onEnded({ _ in
                        vm.timer.upstream.connect().cancel()
                    }))
            } else {
                VStack{
                    ScrollView{
                        ChooseDifficulty(vm: vm.diffVM)
                    }
                    ScrollView{
                        ChooseSubjects(vm: vm.subVM)
                    }
                    if(vm.isCreateActive){
                        NavigationLink("Create", destination: GameRoomView(vm: GameRoomViewModel(asCreator: true, subjects: vm.sendSubjects(), diffs: vm.sendDiffs(), roomName: "")))
                    }
                }
            }
        }
        .onReceive(vm.timer) { _ in
            vm.checkCeateActive()
        }
    }
}

struct MultiplayerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerHomeView()
    }
}
