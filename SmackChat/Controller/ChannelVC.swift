//
//  ChannelVC.swift
//  SmackChat
//
//  Created by sanchez on 26.10.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_LOGIN, sender: sender)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
    
}
