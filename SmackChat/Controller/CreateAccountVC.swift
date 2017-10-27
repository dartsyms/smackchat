//
//  CreateAccountVC.swift
//  SmackChat
//
//  Created by sanchez on 27.10.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: UNWIND, sender: sender)
    }
    
}
