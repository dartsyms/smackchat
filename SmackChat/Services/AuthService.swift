//
//  AuthService.swift
//  SmackChat
//
//  Created by sanchez on 27.10.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
          defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post,
                          parameters: body,
                          encoding: JSONEncoding.default,
                          headers: HEADER
            ).responseString { (response) in
                if response.result.error == nil {
                    completion(true)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post,
                          parameters: body,
                          encoding: JSONEncoding.default,
                          headers: HEADER
            ).responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    let json = JSON(data: data)
                    self.userEmail = json[JSON_REG_USER_EMAIL].stringValue
                    self.authToken = json[JSON_AUTH_TOKEN].stringValue
                    self.isLoggedIn = true
                    completion(true)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            JSON_CREATE_USR_NAME: name,
            JSON_CREATE_USR_EMAIL: lowerCaseEmail,
            JSON_CREATE_USR_AVATAR_NAME: avatarName,
            JSON_CREATE_USR_AVATAR_COLOR: avatarColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post,
                          parameters: body,
                          encoding: JSONEncoding.default,
                          headers: AUTH_HEADER
            ).responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    self.setUserInfo(withData: data)
                    completion(true)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
        }
    }
    
    func setUserInfo(withData data: Data) {
        let json = JSON(data: data)
        let id = json[JSON_CREATE_USR_ID].stringValue
        let color = json[JSON_CREATE_USR_AVATAR_COLOR].stringValue
        let avatarName = json[JSON_CREATE_USR_AVATAR_NAME].stringValue
        let email = json[JSON_CREATE_USR_EMAIL].stringValue
        let name = json[JSON_CREATE_USR_NAME].stringValue
        
        UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: AUTH_HEADER).responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    self.setUserInfo(withData: data)
                    completion(true)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
        }
    }
}
