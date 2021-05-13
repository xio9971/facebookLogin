//
//  ViewController.swift
//  snsLogin
//
//  Created by 민트팟 on 2021/05/11.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, LoginButtonDelegate {
    
    let loginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }()

    var emailLabel = UILabel(frame: CGRect(x: 50, y: 70, width: 200, height: 50))
    
    var nameLabel = UILabel(frame: CGRect(x: 50, y: 140, width: 200, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(emailLabel)
        view.addSubview(nameLabel)
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        
        
        if let token = FBSDKCoreKit.AccessToken.current {
            
            let token = token.tokenString
            //print(type(of: token))
            profileUpdate(token: token)
        }else{
            print("not token..")
        }
    }
    
    func profileUpdate(token: String) {
        
        let param = ["fields": "email, name"]
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: param, tokenString: token, version: nil, httpMethod: .get)
        
        request.start(completionHandler: { [self] connection, result, error in
            //print("\(result)")
            
            let dic = result as! [String: AnyObject]
            
            if let email = dic["email"] {
                emailLabel.text = email as? String
            }
            
            if let name = dic["name"] {
                nameLabel.text = name as? String
            }
            
        })
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("login success")
        
        guard let token = result?.token?.tokenString else {
            return
        }
        
        profileUpdate(token: token)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        emailLabel.text = ""
        nameLabel.text = ""
    }
    

    // Swift // // Add this to the header of your file, e.g. in ViewController.swift import FBSDKLoginKit // Add this to the body class ViewController: UIViewController { override func viewDidLoad() { super.viewDidLoad() let loginButton = FBLoginButton() loginButton.center = view.center view.addSubview(loginButton) }

    // Swift override func viewDidLoad() { super.viewDidLoad() if let token = AccessToken.current, !token.isExpired { // User is logged in, do work such as go to next view controller. } }
        
    
    
}

