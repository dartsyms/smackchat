//
//  ChannelVC.swift
//  SmackChat
//
//  Created by sanchez on 26.10.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }

}
