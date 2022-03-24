//
//  LeadreboardService.swift
//  QuizProject
//
//  Created by Martin Dinev on 27.02.22.
//

import Foundation
import Combine
import FirebaseDatabase

class LeaderboardService {
    
    func getTop10Players() -> AnyPublisher<[SessionUserDetails], Error> {
        
        Deferred {
            Future { promise in
                Database.database().reference()
                    .child("users")
                    .getData { error, users in
                        guard error == nil else {
                            promise(.failure(error!))
                            print(error!.localizedDescription)
                            return;
                        }
                        
                        var topUsers: [SessionUserDetails] = []
                        let data = users.value as? [String:[String:Any]]
                        
                        for (_, value) in data! {
                            var username = ""
                            var points = 0
                            for info in value {
                                if (info.key == "username"){
                                    username = (info.value as? String)!
                                }
                                if (info.key == "points"){
                                    points = (info.value as? Int)!
                                }
                            }
                            topUsers.append(SessionUserDetails(username: username, points: points, last_day_played: "", played_games: 0))
                        }
                        topUsers.sort(by: {$0.points > $1.points})
                        while (topUsers.count > 10){
                            topUsers.remove(at: 10)
                        }
                        promise(.success(topUsers))
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
