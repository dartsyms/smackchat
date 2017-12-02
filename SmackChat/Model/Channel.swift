//
//  Channel.swift
//  SmackChat
//
//  Created by sanchez on 01.12.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import Foundation

struct Channel: Decodable {
    public private(set) var _id: String!
    public private(set) var name: String!
    public private(set) var description: String!
    public private(set) var __v: Int?
}
