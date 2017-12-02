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
let TO_AVATAR_PICKER = "toAvatarPicker"

// Identifiers
let AVATAR_CELL_ID = "avatarCell"
let CHANNEL_CELL_ID = "channelCell"
let MESSAGE_CELL_ID = "messageCell"

// Colors
let smackPurplePlaceholder = #colorLiteral(red: 0.3631127477, green: 0.4045833051, blue: 0.8775706887, alpha: 0.5)

// Notifications
let NOTIFICATION_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIFICATION_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIFICATION_CHANNEL_SELECTED = Notification.Name("channelSelected")

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// URL Constants
let BASE_URL = "https://localhost:3005/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel/"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel/"

// Headers
let HEADER = ["Content-Type": "application/json; charset=utf-8"]
let AUTH_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]

// Fields
let JSON_REG_USER_EMAIL = "user"
let JSON_AUTH_TOKEN = "token"
let JSON_CREATE_USR_ID = "_id"
let JSON_CREATE_USR_AVATAR_COLOR = "avatarColor"
let JSON_CREATE_USR_AVATAR_NAME = "avatarName"
let JSON_CREATE_USR_EMAIL = "email"
let JSON_CREATE_USR_NAME = "name"
