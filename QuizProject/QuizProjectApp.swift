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
    
    var body: some Scene {
        WindowGroup {
            switch sessionService.state {
            case .loggedIn:
                NavigationView{
                    ZStack{
                        Color(UIColor(hue: 0.1056, saturation: 0.06, brightness: 0.98, alpha: 1.0)).ignoresSafeArea(.all)
                    HomeView()
                        .environmentObject(sessionService)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                    }
                }
            case .loggedOut:
                ZStack{
                    Color(UIColor(hue: 0.1056, saturation: 0.06, brightness: 0.98, alpha: 1.0)).ignoresSafeArea(.all)
                LoginView()
                }
            }
        }
    }
}
