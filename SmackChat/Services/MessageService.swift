//
//  MessageService.swift
//  SmackChat
//
//  Created by sanchez on 01.12.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import Foundation
import Alamofire

class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var unreadChannels = [String]()
    var selectedChannel: Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: AUTH_HEADER
            ).responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    // new Swift 4 style
                    do {
                        self.channels = try JSONDecoder().decode([Channel].self, from: data)
                    } catch let error {
                        debugPrint(error as Any)
                    }
                    NotificationCenter.default.post(name: NOTIFICATION_CHANNELS_LOADED, object: nil)
                    completion(true)
                } else {
                    debugPrint(response.result.error as Any)
                    completion(false)
                }
        }
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)",
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: AUTH_HEADER
            ).responseJSON { (response) in
                if response.result.error == nil {
                    self.clearMessages()
                    guard let data = response.data else { return }
                    do {
                        self.messages = try JSONDecoder().decode([Message].self, from: data)
                    } catch let error {
                        debugPrint(error as Any)
                    }
                    completion(true)
                } else {
                    debugPrint(response.result.error as Any)
                    completion(false)
                }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
}
