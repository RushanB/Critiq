//
//  ViewController.swift
//  Critiq
//
//  Created by Rushan on 2017-07-03.
//  Copyright © 2017 RushanBenazir. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TwitterKit
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //facebook
        setupFacebookButton()
        
        //twitter
        setupTwitterButton()
    }
    
    //MARK: Twitter Helper Methods
    fileprivate func setupTwitterButton(){
        let twitterButton = TWTRLogInButton { (session, error) in
            if let err = error{
                print("Failed to login to Twitter: ", err)
                return
            }
            print("===========Login Successful to Twitter===========")
            
            //firebase login with twitter
            guard let token = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            let credential = TwitterAuthProvider.credential(withToken: token, secret: secret)
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                if let err = error {
                    print("Failed to login to Firebase with Twitter: ", err)
                    return
                }
                print("Successfully created firebase-twitter user: ", user?.uid ?? "")
                
            })
        }
        
        view.addSubview(twitterButton)
        twitterButton.frame = CGRect(x: 16, y: 50 + 66, width: view.frame.width - 32, height: 50)
    }
    
    //MARK: Facebook Helper Methods
    fileprivate func setupFacebookButton(){
        let facebookButton = FBSDKLoginButton()
        view.addSubview(facebookButton)
        facebookButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email", "public_profile"]
    }
    
    //log in button delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        print("===========Login Successful to FB===========")
        self.fetchProfile()
        
    }
    
    //helper method
    func fetchProfile(){
        print("===========Fetching Facebook Profile===========")
        //firebase authorization
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            print("Successfully created firebase-facebook user: ", user ?? "")
            
        }
        
        //graph request
        let parameters = ["fields": "id, name, email, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "/me", parameters: parameters).start { (connection, result, error) in
            
            if error != nil {
                print("Failed to start graph request:", error ?? "")
                return
            }
            
            print(result ?? "" )
            
//            //fetch email
//            if let email = result["email"] as? String {
//                print(email)
//            }
//            //fetch pictures
//            if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
//                print(url)
//            }
        }
    }
    
    //log out button delegate
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("===========Logged out of FB===========")
    }
    
}

