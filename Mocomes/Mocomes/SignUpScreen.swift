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

  func signup() {
    guard let email = signupEmail.text else  { return }
    guard let password = signupPassword.text else { return }
    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
      if error == nil{
        user?.sendEmailVerification(completion: { (error) in
          if error == nil {
            self.transitionToLogin()
          }else {
            print("\(error?.localizedDescription)")
          }
        })
      }else {
        print("\(error?.localizedDescription)")
      }
    })
  }

  func transitionToLogin() {
    let storyboard: UIStoryboard = UIStoryboard(name: "LoginScreen", bundle: nil)
    let LoginTransition = storyboard.instantiateInitialViewController() as! LoginScreen
    LoginTransition.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    self.present(LoginTransition, animated: true, completion: nil)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
