//
//  AppDelegate.swift
//  Mocomes
//
//  Created by ytzuki on 2016/12/28.
//  Copyright © 2016年 ytzuki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var navigationController: UINavigationController?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let storyboard: UIStoryboard = UIStoryboard(name: "MenuScreen", bundle: Bundle.main)
    let mainViewController: UIViewController = storyboard.instantiateInitialViewController()! as UIViewController
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.navigationController = UINavigationController(rootViewController: mainViewController)
    self.window?.rootViewController = navigationController
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

