//
//  LoginViewController.swift
//  DNews
//
//  Created by robert pham on 6/19/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: BaseViewController, AuthenticationStoryboardInstance {

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var googleSigninButton: GIDSignInButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTf: BaseTextField!
    @IBOutlet weak var passwordTf: BaseTextField!
    @IBOutlet weak var signupButton: UIButton!
    let handler = LoginHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.backgroundColor = AppColor.buttonColor
        signupButton.setTitleColor(UIColor.flatRedColor(), forState: .Normal)
        FBSDKLoginManager().logOut()
        facebookLoginButton.readPermissions = ["email"]
        facebookLoginButton.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let skipButton = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: #selector(LoginViewController.skip))
        self.navigationItem.rightBarButtonItem = skipButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func skip() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let (success, msg) = handler.validate(emailTf.text, password: passwordTf.text)
        if success {
            showLoadingOnView(self.view)
            handler.login(emailTf.text!, password: passwordTf.text!, completion: { [weak self] (success, error) in
                removeAllLoadingOnView(self?.view)
                if success {
                    self?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    showErrorNotification(text: error?.failureReason)
                }
            })
        } else {
            showErrorNotification(text: msg)
        }
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        let signupVc = SignupViewController.createInstance()
        self.navigationController?.pushViewController(signupVc, animated: true)
    }

}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            showSimpleAlert(title: nil, message: "Something went wrong. Please try again.")
        } else if result.isCancelled {
            showSimpleAlert(title: nil, message: "Please allow permission to login")
        } else {
            showLoadingOnView(self.view)
            handler.loginFacebook(result.token.tokenString, completion: { [weak self] (success, error) in
                removeAllLoadingOnView(self?.view)
                if success {
                    self?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    showErrorNotification(text: error?.failureReason)
                }
            })
        }
    }
}

extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            showSimpleAlert(title: nil, message: "Error when login by Google")
        } else {
            showLoadingOnView(self.view)
            handler.loginGoogle(user.authentication.accessToken, completion: { [weak self] (success, error) in
                removeAllLoadingOnView(self?.view)
                if success {
                    self?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    showErrorNotification(text: error?.failureReason)
                }
            })
        }
    }
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        
    }
}
private let didshowKey = "com.jp.showlogin.firsttime"
extension LoginViewController {
    class func checkShowLoginForFirstTime(vc: UIViewController) {
        let showed = NSUserDefaults.standardUserDefaults().boolForKey(didshowKey)
        if showed == false {
            dispatch_async(dispatch_get_main_queue(), { 
                let loginVc = LoginViewController.createInstance()
                let nav = UINavigationController(rootViewController: loginVc)
                vc.presentViewController(nav, animated: true, completion: nil)
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: didshowKey)
            })
        }
    }
}
