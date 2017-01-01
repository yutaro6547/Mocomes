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
  var initialview: UITabBarController?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FIRApp.configure()

    let storyboard: UIStoryboard = UIStoryboard(name: "SignUpScreen", bundle: Bundle.main)
    let mainViewController: UITabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.initialview = mainViewController
    self.window?.rootViewController = initialview
    self.window?.makeKeyAndVisible()

/*  画面上部に表示しようとしたが保留
    //ここから追記
    //TabBarのサイズと、全体のサイズを取得
    let t_height: CGFloat = self.initialview!.tabBar.frame.size.height;
    let w_width: CGFloat = self.window!.frame.size.width;
    let w_height: CGFloat = self.window!.frame.size.height;

    //TabBarを移動
    self.initialview?.tabBar.frame = CGRect(x: 0.0, y: 0.0, width: w_width, height: t_height)

    //コンテンツ表示部を移動
    let contentView: UIView = (self.initialview?.tabBar.superview)!
    contentView.frame = CGRect(x: 0, y: t_height, width: w_width, height: w_height - t_height)
*/
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

