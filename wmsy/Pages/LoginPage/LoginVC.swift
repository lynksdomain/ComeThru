//
//  LoginVC.swift
//  wmsy
//
//  Created by C4Q on 3/15/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Kingfisher
import FirebaseAuth
import SVProgressHUD

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var name: String?
        var id: String?
        var profilePictureUrl: String?
        init(rawResponse: Any?) {
            guard let response = rawResponse as? Dictionary<String, Any> else {
                return
            }
            
            if let name = response["name"] as? String {
                self.name = name
            }
            
            if let id = response["id"] as? String {
                self.id = id
            }
            
            
            if let picture = response["picture"] as? Dictionary<String, Any> {
                if let data = picture["data"] as? Dictionary<String, Any> {
                    if let url = data["url"] as? String {
                        self.profilePictureUrl = url
                    }
                }
            }
        }
    }
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, picture.type(large)"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}


class LoginVC: UIViewController {
    
    let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        view.addSubview(loginView)
    }
    let connection = GraphRequestConnection()
    
}



extension LoginVC: loginViewDelegate {
    func loginButtonPressed() {
        let loginManager = LoginManager()
        loginManager.logIn( readPermissions: [.publicProfile,.userBirthday], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
                
            // Logged In
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                SVProgressHUD.show()
                self.connection.add(MyProfileRequest()) { response, result in
                    switch result {
                    case .success(let response):
                        let cred = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                        Auth.auth().signIn(with: cred, completion: { (user, error) in
                            guard let user = user else {
                                if let error = error {
                                    print("error logging in?")
                                }
                                return
                            }
                            // Configure rest of app
                            DBService.manager.checkIfUserExists(userID: user.uid, completion: { (userAlreadyExists) in
                                var currentUser: AppUser!
                                if userAlreadyExists {
                                    DBService.manager.getAppUser(fromID: user.uid, completion: { (appUser) in
                                        if let appUser = appUser {
                                            currentUser = appUser
                                            AppUser.currentAppUser = currentUser
                                            print("set up everything already")
                                            (self.tabBarController as? MainTabBarVC)?.animateTo(page: .feedAndMap, fromViewController: self)
                                        } else {
                                            print("some other error here")
                                        }
                                    })
                                } else {
                                    let userName = response.name
                                    let userID = user.uid
                                    if let photoID = response.profilePictureUrl{
                                        currentUser = AppUser(name: userName!, photoID: photoID, age: "", userID: userID, bio: "", badge: false, flags: 0, hostedWhims: [], interests: [])
                                        AppUser.currentAppUser = currentUser
                                        DBService.manager.addAppUser(currentUser)
                                        print("set up everything already")
                                        (self.tabBarController as? MainTabBarVC)?.animateTo(page: .feedAndMap, fromViewController: self)
                                    }
                                }
                            })
                        })
                    case .failed(let error):
                        print("Custom Graph Request Failed: \(error)")
                    }
                }
                self.connection.start()
            }
        }
    }
}

