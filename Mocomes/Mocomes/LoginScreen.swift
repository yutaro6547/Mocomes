//
//  LoginScreen.swift
//  Mocomes
//
//  Created by ytzuki on 2017/01/01.
//  Copyright © 2017年 ytzuki. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginScreen: UIViewController, UITextFieldDelegate {
  @IBOutlet var emailLogin: UITextField!
  @IBOutlet var passwordLogin: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    emailLogin.delegate = self
    passwordLogin.delegate = self
    passwordLogin.isSecureTextEntry = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func loginButton() {
    login()
  }

  func login() {
    //EmailとPasswordのTextFieldに文字がなければ、その後の処理をしない
    guard let email = emailLogin.text else { return }
    guard let password = passwordLogin.text else { return }

    //signInWithEmailでログイン
    //第一引数にEmail、第二引数にパスワードを取ります
    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
      //エラーがないことを確認
      if error == nil {
        if let loginUser = user {
          // バリデーションが完了しているか確認。完了ならそのままログイン
          if self.checkUserValidate(loginUser) {
            // 完了済みなら、ListViewControllerに遷移
            self.transitionToView()
          }else {
            // 完了していない場合は、アラートを表示
            self.presentValidateAlert()
          }
        }
      }else {
        print("error...\(error?.localizedDescription)")
      }
    })
  }

  // ログインした際に、バリデーションが完了しているか返す
  func checkUserValidate(_ user: FIRUser)  -> Bool {
    return user.isEmailVerified
  }

  // メールのバリデーションが完了していない場合のアラートを表示
  func presentValidateAlert() {
    let alert = UIAlertController(title: "メール認証", message: "メール認証を行ってください", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

  //Returnキーを押すと、キーボードを隠す
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  func transitionToView()  {
    // storyboardのインスタンス取得
    let storyboard: UIStoryboard = UIStoryboard(name: "MenuScreen", bundle: nil)
    // 遷移先のTeacherSetingを指定してstoryboardをインスタンス化
    let LoginTransition = storyboard.instantiateInitialViewController() as! MenuScreen
    // アニメーション設定
    LoginTransition.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    // 画面遷移
    self.present(LoginTransition, animated: true, completion: nil)
  }
}
