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
        if user != nil {
          self.transitionToView()
        }
      }else {
        print("error...\(error?.localizedDescription)")
      }
    })
  }

  //Returnキーを押すと、キーボードを隠す
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  //ログイン完了後に、ListViewControllerへの遷移のためのメソッド
  func transitionToView()  {
    self.performSegue(withIdentifier: "toVC", sender: self)
  }
}
