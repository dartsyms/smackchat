//
//  Constants.swift
//  SmackChat
//
//  Created by sanchez on 27.10.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// URL Constants
let BASE_URL = "https://localhost:3005/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
