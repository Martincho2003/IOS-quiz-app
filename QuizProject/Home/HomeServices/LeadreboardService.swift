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
//                    .queryOrdered(byChild: "points")
//                    .queryLimited(toFirst: 10)
                    .getData { error, users in
                        guard error == nil else {
                            promise(.failure(error!))
                            print(error!.localizedDescription)
                            return;
                        }
//                        for userInfo in users.children {
//                            let userDict = userInfo
////                            for user in userInfo as! [String:AnyObject] {
////                                let username = user["username"] as! String
////                                let points = user["points"] as! Int
////                            }
//                            print((userInfo as AnyObject).value(forKey: "points"))
//                        }
                        
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
                        promise(.success(topUsers))
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
