//
//  QuizProjectApp.swift
//  QuizProject
//
//  Created by Martin Dinev on 22.12.21.
//

import SwiftUI
import Firebase

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct QuizProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                switch sessionService.state {
                case .loggedIn:
                    HomeView()
                        .environmentObject(sessionService)
                case .loggedOut:
                    LoginView()
                }
            }
        }
    }
}
