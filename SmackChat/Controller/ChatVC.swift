//
//  ChatVC.swift
//  SmackChat
//
//  Created by sanchez on 26.10.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sendButton.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(),
                          action: #selector(SWRevealViewController.revealToggle(_:)),
                          for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ChatVC.userDataDidChange(_:)),
                                               name: NOTIFICATION_USER_DATA_DID_CHANGE,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ChatVC.channelSelected(_:)),
                                               name: NOTIFICATION_CHANNEL_SELECTED,
                                               object: nil)
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?._id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                self.scrollChatToBottom()
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?._id else { return }
            var names = ""
            var numberOfTypers = 0
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUsersLbl.text = "\(names) \(verb) typing a message"
            } else {
                self.typingUsersLbl.text = ""
            }
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please, Log In"
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelTitle = MessageService.instance.selectedChannel?.name ?? ""
        channelNameLbl.text = "#\(channelTitle)"
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?._id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            self.tableView.reloadData()
            self.scrollChatToBottom()
        }
    }
    
    func scrollChatToBottom() {
        if MessageService.instance.messages.count > 0 {
            let endIndex = IndexPath(row: MessageService.instance.messages.count - 1,
                                     section: 0)
            self.tableView.scrollToRow(at: endIndex,
                                       at: .bottom,
                                       animated: false)
        }
    }
    
    @IBAction func msgBoxEditing(_ sender: UITextField) {
        guard let channelId = MessageService.instance.selectedChannel?._id else { return }
        if messageTxtBox.text == "" {
            isTyping = false
            sendButton.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
        } else {
            if !isTyping {
                sendButton.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
    }

    @IBAction func sendMessagePressed(_ sender: UIButton) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?._id else { return }
            guard let message = messageTxtBox.text else { return }
            SocketService.instance.addMessage(messageBody: message,
                                              userId: UserDataService.instance.id,
                                              channelId: channelId,
                                              completion: { (success) in
                                                if success {
                                                    self.messageTxtBox.text = ""
                                                    self.messageTxtBox.resignFirstResponder()
                                                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                                                }
            })
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MESSAGE_CELL_ID,
                                                    for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
