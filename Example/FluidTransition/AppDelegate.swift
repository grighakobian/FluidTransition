//
//  AppDelegate.swift
//  FluidTransition
//
//  Created by Grigor Hakobyan on 10/17/2021.
//  Copyright (c) 2021 Grigor Hakobyan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: RootViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

