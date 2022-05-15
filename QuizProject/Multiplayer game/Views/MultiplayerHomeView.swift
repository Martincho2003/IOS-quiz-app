//
//  GameRoomView.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import SwiftUI

struct MultiplayerHomeView: View {
    
    @StateObject var vm: MultiplayerHomeVM = MultiplayerHomeVM()
    
    var body: some View {
        ZStack {
            Color(UIColor(hue: 0.1056, saturation: 0.06, brightness: 0.98, alpha: 1.0)).ignoresSafeArea(.all)
            VStack{
                if (!vm.showGameDetails){
                    HStack{
                        Spacer()
                            .frame(width: 30)
                        ButtonView(title: "Create Room") {
                            vm.showGameDetails.toggle()
                        }
                        Spacer()
                            .frame(width: 30)
                    }
                    HStack{
                        Spacer()
                            .frame(width: 30)
                        NavigationLink("Join Room", destination: ChooseRoomView())
                            .simultaneousGesture(TapGesture().onEnded({ _ in
                                vm.timer.upstream.connect().cancel()
                            }))
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(.brown)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                            .cornerRadius(10)
                        Spacer()
                            .frame(width: 30)
                    }
                } else {
                    VStack{
                        ScrollView{
                            ChooseDifficulty(vm: vm.diffVM)
                        }
                        ScrollView{
                            ChooseSubjects(vm: vm.subVM)
                        }
                        if(vm.isCreateActive){
                            HStack{
                                Spacer()
                                    .frame(width: 30)
                                NavigationLink("Create", destination: GameRoomView(vm: GameRoomViewModel(asCreator: true, subjects: vm.sendSubjects(), diffs: vm.sendDiffs(), roomName: "")))
                                    .frame(maxWidth: .infinity, maxHeight: 45)
                                    .background(.brown)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .cornerRadius(10)
                                Spacer()
                                    .frame(width: 30)
                            }
                        }
                        Spacer()
                            .frame(height: 20)
                    }
                }
            }
            .onReceive(vm.timer) { _ in
                vm.checkCeateActive()
        }
        }
    }
}

struct MultiplayerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerHomeView()
    }
}
