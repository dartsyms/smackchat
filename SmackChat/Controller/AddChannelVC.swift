//
//  AddChannelVC.swift
//  SmackChat
//
//  Created by sanchez on 01.12.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var channelDesc: UITextField!
    @IBOutlet weak var bgView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeModalPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: UIButton) {
        guard let name = nameTxt.text, nameTxt.text != "" else { return }
        guard let desc = channelDesc.text, channelDesc.text != "" else { return }
        SocketService.instance.addChannel(channelName: name, channelDescription: desc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self,
                                                action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name",
                                                           attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        channelDesc.attributedPlaceholder = NSAttributedString(string: "description",
                                                               attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
