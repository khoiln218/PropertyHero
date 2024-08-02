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
import SDWebImageWebPCoder

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let nav = UINavigationController()
    var assembler: Assembler = DefaultAssembler()
    var disposeBag = DisposeBag()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        UINavigationBar.appearance().tintColor = UIColor(hex: "#424242")
        
        GMSServices.provideAPIKey("AIzaSyCweUKlL7MrYKl5qXC1YBL6U4y4DSZZTn4")
        
        let WebPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(WebPCoder)
        
        window.overrideUserInterfaceStyle = .light
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: nil
        )
        
        bindViewModel()
    }
    
    func bindViewModel() {
        let homeVC:HomeViewController = assembler.resolve(navigationController: nav)
        homeVC.tabBarItem.title = nil
        if let image = UIImage(named: "ic_action_home")?.withRenderingMode(.alwaysOriginal) {
            homeVC.tabBarItem.image = image
        }
        if let image = UIImage(named: "ic_action_home_active")?.withRenderingMode(.alwaysOriginal) {
            homeVC.tabBarItem.selectedImage = image
        }
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
        
        let collectionVC:CollectionViewController = assembler.resolve(navigationController: nav)
        collectionVC.tabBarItem.title = nil
        if let image = UIImage(named: "ic_action_collection")?.withRenderingMode(.alwaysOriginal) {
            collectionVC.tabBarItem.image = image
        }
        if let image = UIImage(named: "ic_action_collection_active")?.withRenderingMode(.alwaysOriginal) {
            collectionVC.tabBarItem.selectedImage = image
        }
        collectionVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
        
        let searchVC:SearchViewController = assembler.resolve(navigationController: nav)
        searchVC.tabBarItem.title = nil
        if let image = UIImage(named: "ic_action_search")?.withRenderingMode(.alwaysOriginal) {
            searchVC.tabBarItem.image = image
        }
        if let image = UIImage(named: "ic_action_search_active")?.withRenderingMode(.alwaysOriginal) {
            searchVC.tabBarItem.selectedImage = image
        }
        searchVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
        
        let notificationVC:NotificationViewController = assembler.resolve(navigationController: nav)
        notificationVC.tabBarItem.title = nil
        if let image = UIImage(named: "ic_action_notification")?.withRenderingMode(.alwaysOriginal) {
            notificationVC.tabBarItem.image = image
        }
        if let image = UIImage(named: "ic_action_notification_active")?.withRenderingMode(.alwaysOriginal) {
            notificationVC.tabBarItem.selectedImage = image
        }
        notificationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
        
        let personVC:MoreViewController = assembler.resolve(navigationController: nav)
        personVC.tabBarItem.title = nil
        if let image = UIImage(named: "ic_action_person")?.withRenderingMode(.alwaysOriginal) {
            personVC.tabBarItem.image = image
        }
        if let image = UIImage(named: "ic_action_person_active")?.withRenderingMode(.alwaysOriginal) {
            personVC.tabBarItem.selectedImage = image
        }
        personVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
        
        let tabbarController = UITabBarController()
        tabbarController.delegate = self
        tabbarController.viewControllers = [homeVC, searchVC, collectionVC, notificationVC, personVC]
        
        nav.viewControllers.removeAll()
        nav.viewControllers.append(tabbarController)
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if url.scheme == "fb835680071452810" {
            return ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        } else if url.scheme == "propertyhero" || url.scheme == "http" || url.scheme == "https" {
            return handleDeepLink(url: url)
        }
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func handleDeepLink(url: URL) -> Bool {
        print(url)
        
        let pathComponents = url.pathComponents
        
        if pathComponents.count > 1 {
            let firstSegment = pathComponents[1]
            switch firstSegment {
            case "home":
                navigateToHome()
            case "profile":
                navigateToProfile()
            default:
                print(firstSegment)
                break
            }
        }
        return true
    }
    
    func navigateToHome() {
        // Implementation for navigating to the home screen
        print(#function)
    }
    
    func navigateToProfile() {
        // Implementation for navigating to the profile screen
        print(#function)
    }
}

extension AppDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is CollectionViewController {
            if !AccountStorage().isLogin() {
                let loginVC:LoginViewController = assembler.resolve(navigationController: nav)
                nav.pushViewController(loginVC, animated: true)
                return false
            }
            return true
        } else if viewController is NotificationViewController {
            if !AccountStorage().isLogin() {
                let loginVC:LoginViewController = assembler.resolve(navigationController: nav)
                nav.pushViewController(loginVC, animated: true)
                return false
            }
            return true
        }
        return true
    }
}
