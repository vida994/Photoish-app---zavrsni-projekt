//
//  AppDelegate.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = configureTabViewController()
        return true
    }
    
    func configureTabViewController() -> UITabBarController {
        let tab = UITabBarController(nibName: nil, bundle: nil)
        let homeViewController = HomeViewController(viewModel: HomeViewModelImpl(picturesRepository: PicturesRepositoryImpl(networkManager: NetworkManager())))
        tab.setViewControllers([homeViewController], animated: true)
        return tab
    }



}

