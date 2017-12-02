//
//  UserDataService.swift
//  SmackChat
//
//  Created by sanchez on 01.12.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import Foundation

class UserDataService {
    static let instance = UserDataService()
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func getBackgroundColor(fromComponents components: String) -> UIColor {
        var r, g, b, a: NSString?
        
        let scanner = Scanner(string: components)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "[], ")
        
        scanner.scanUpToCharacters(from: CharacterSet(charactersIn: ","), into: &r)
        scanner.scanUpToCharacters(from: CharacterSet(charactersIn: ","), into: &g)
        scanner.scanUpToCharacters(from: CharacterSet(charactersIn: ","), into: &b)
        scanner.scanUpToCharacters(from: CharacterSet(charactersIn: ","), into: &a)
        
        guard let rUnwrapped = r, let gUnwrapped = g, let bUnwrapped = b, let aUnwrapped = a
            else { return UIColor.lightGray}

        return UIColor(red: CGFloat(rUnwrapped.doubleValue),
                       green: CGFloat(gUnwrapped.doubleValue),
                       blue: CGFloat(bUnwrapped.doubleValue),
                       alpha: CGFloat(aUnwrapped.doubleValue))
    }
    
    func logoutUser() {
        id = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageService.instance.clearChannels()
    }
}
