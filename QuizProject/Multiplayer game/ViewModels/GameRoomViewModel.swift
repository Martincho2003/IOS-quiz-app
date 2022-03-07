//
//  GameRoomViewModel.swift
//  QuizProject
//
//  Created by Martin Dinev on 4.03.22.
//

import Foundation

class GameRoomViewModel: ObservableObject {
    var asCreator: Bool
    private var multiplayerService = MultiplayerGameService()
    @Published var room: Room = Room(admin: SessionUserDetails(username: "", points: -1, last_day_played: "", played_games: -1), subjects: [], difficutlies: [], users: [], questions: [])
    
    init(asCreator: Bool, subjects: [Subject], diffs: [Difficulty]) {
        self.asCreator = asCreator
        if (asCreator){
            multiplayerService.createRoom(subjects: subjects, diffs: diffs)
        } else {
            //multiplayerService.joinRoom()
        }
        //room = multiplayerService.getRoom()
    }
}
