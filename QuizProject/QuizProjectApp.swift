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
            switch sessionService.state {
            case .loggedIn:
                //HomeView()
                //coordinator.homeView().environmentObject(sessionService)
                NavigationView{
                    HomeView().environmentObject(sessionService)
                }
            case .loggedOut:
                LoginView()
            }
        }
    }
}

class Coordinator {
    var difficulties: [Difficulty] = []
    var subjects: [Subject] = []
    @Published var homeViewModel = HomeViewModel()
    @ObservedObject var difficultyVM = DifficultyViewModel()
    
    func homeView() -> some View {
        if (homeViewModel.showGameMode){
            return AnyView(ChooseDifficulty(vm: difficultyVM))
        }
        
        //let homeView =
        return AnyView(HomeView())
    }
}
