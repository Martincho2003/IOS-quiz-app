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
                Text("\(user.username): \(user.points)")
            }
        }
    }
}

struct MultiplayerEndView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerEndView(vm: MultiplayerEndVM(users: []))
    }
}
