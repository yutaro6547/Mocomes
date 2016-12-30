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
    // segueを使用しない場合
    // storyboardのインスタンス取得
    let storyboard: UIStoryboard = UIStoryboard(name: "TalkScreen", bundle: nil)
    // 遷移先のTeacherSetingを指定してstoryboardをインスタンス化
    let settingTransition = storyboard.instantiateInitialViewController() as! TalkScreen
    // アニメーション設定
    settingTransition.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    // 画面遷移
    self.present(settingTransition, animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
