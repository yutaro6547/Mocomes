//
//  SignUpScreen.swift
//  Mocomes
//
//  Created by 鈴木裕太朗 on 2017/01/01.
//  Copyright © 2017年 ytzuki. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpScreen: UIViewController, UITextFieldDelegate {
  @IBOutlet var signupEmail: UITextField!
  @IBOutlet var signupPassword: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    signupEmail.delegate = self
    signupPassword.delegate = self
    signupPassword.isSecureTextEntry = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func willSignup() {
    signup()
  }

  @IBAction func willLogin() {
    transitionToLogin()
  }

  //Signupのためのメソッド
  func signup() {
    //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
    guard let email = signupEmail.text else  { return }
    guard let password = signupPassword.text else { return }
    //FIRAuth.auth()?.createUserWithEmailでサインアップ
    //第一引数にEmail、第二引数にパスワード
    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
      //エラーなしなら、認証完了
      if error == nil{
        // エラーがない場合にはそのままログイン画面に飛び、ログインしてもらう
        self.transitionToLogin()
    } else {

      print("\(error?.localizedDescription)")
    }
   })
  }

  func transitionToLogin() {
    // storyboardのインスタンス取得
    let storyboard: UIStoryboard = UIStoryboard(name: "LoginScreen", bundle: nil)
    // 遷移先のTeacherSetingを指定してstoryboardをインスタンス化
    let LoginTransition = storyboard.instantiateInitialViewController() as! LoginScreen
    // アニメーション設定
    LoginTransition.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    // 画面遷移
    self.present(LoginTransition, animated: true, completion: nil)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
