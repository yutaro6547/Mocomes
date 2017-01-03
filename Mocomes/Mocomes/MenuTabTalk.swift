//
//  MenuTabTalk.swift
//  Mocomes
//
//  Created by 鈴木裕太朗 on 2016/12/31.
//  Copyright © 2016年 ytzuki. All rights reserved.
//

import UIKit

class MenuTabTalk: UIViewController {
  
  @IBAction func testButton(_ sender: Any) {
    let storyboard: UIStoryboard = UIStoryboard(name: "TalkScreen", bundle: nil)
    let settingTransition = storyboard.instantiateInitialViewController() as! TalkScreen
    settingTransition.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    self.present(settingTransition, animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
