//
//  ChannelCell.swift
//  SmackChat
//
//  Created by sanchez on 01.12.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        channelName.text = "#\(channel.name)"
        channelName.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        for id in MessageService.instance.unreadChannels {
            if id == channel._id {
                channelName.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            }
        }
    }

}
