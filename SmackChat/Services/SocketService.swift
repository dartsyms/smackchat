//
//  SocketService.swift
//  SmackChat
//
//  Created by sanchez on 02.12.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let name = dataArray[0] as? String else { return }
            guard let desc = dataArray[1] as? String else { return }
            guard let id = dataArray[2] as? String else { return }
            let newChannel = Channel(_id: id, name: name, description: desc, __v: 0)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else { return }
            guard let usrId = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let usrName = dataArray[3] as? String else { return }
            guard let usrAvatar = dataArray[4] as? String else { return }
            guard let usrAvatarColor = dataArray[5] as? String else { return }
            guard let msgId = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            let newMsg = Message(_id: msgId,
                                 messageBody: msgBody,
                                 userId: usrId,
                                 channelId: channelId,
                                 userName: usrName,
                                 userAvatar: usrAvatar,
                                 userAvatarColor: usrAvatarColor,
                                 __v: 0,
                                 timeStamp: timeStamp)
            
            completion(newMsg)
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
    }
}
