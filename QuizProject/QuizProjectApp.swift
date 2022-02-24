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
    let coordinator: Coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                switch sessionService.state {
                case .loggedIn:
                    //HomeView()
                    coordinator.homeView().environmentObject(sessionService)
                    //HomeView().environmentObject(sessionService)
                case .loggedOut:
                    LoginView()
                }
            }
        }
    }
}

class Coordinator {
    @EnvironmentObject var sessionService: SessionServiceImpl
    var difficulties: [Difficulty] = []
    var subjects: [Subject] = []
    
    func homeView() -> HomeView {
        //let homeViewModel = HomeViewModel()
//        homeViewModel.gameClicked = {
//            //show difficulty
//        }
        let homeView = HomeView()
        return homeView
    }
}
