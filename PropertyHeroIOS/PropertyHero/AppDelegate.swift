//
//  AppDelegate.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/5/23.
//

import RxCocoa
import RxSwift
import UIKit
import GoogleMaps
import GoogleSignIn
import FacebookCore

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var assembler: Assembler = DefaultAssembler()
    var disposeBag = DisposeBag()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        UINavigationBar.appearance().tintColor = UIColor(hex: "#424242")
        
        GMSServices.provideAPIKey("AIzaSyCweUKlL7MrYKl5qXC1YBL6U4y4DSZZTn4")
        
        window.overrideUserInterfaceStyle = .light
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: nil
        )
        
        bindViewModel(window: window)
    }
    
    private func bindViewModel(window: UIWindow) {
        let vc: SplashViewController = assembler.resolve(window: window)
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if url.scheme == "fb835680071452810" {
            return ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }
         return GIDSignIn.sharedInstance.handle(url)
    }
}
