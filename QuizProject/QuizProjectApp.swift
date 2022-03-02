//
//  QuizProjectApp.swift
//  QuizProject
//
//  Created by Martin Dinev on 22.12.21.
//

import SwiftUI
import Firebase
import FBSDKCoreKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        return true
    }
    
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {

            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )

        }
    
}

@main
struct QuizProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    //let coordinator: Coordinator = Coordinator()
    
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
