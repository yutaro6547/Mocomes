//
//  AppDelegate.swift
//  Mocomes
//
//  Created by ytzuki on 2016/12/28.
//  Copyright © 2016年 ytzuki. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var initialview: UIViewController?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FIRApp.configure()

    let storyboard: UIStoryboard = UIStoryboard(name: "SignUpScreen", bundle: Bundle.main)
    let mainViewController: UIViewController = storyboard.instantiateInitialViewController()!
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.initialview = mainViewController
    self.window?.rootViewController = initialview
    self.window?.makeKeyAndVisible()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }
}

