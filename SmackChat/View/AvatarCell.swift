//
//  AvatarCell.swift
//  SmackChat
//
//  Created by sanchez on 01.12.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configureCell(index: Int, type: AvatarType) {
        switch (type) {
        case .dark:
            avatarImg.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        case .light:
            avatarImg.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
    }
    
    func setupView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}
