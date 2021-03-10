//
//  Tweet.swift
//  ATTwitterClone
//
//  Created by Alvin Tu on 3/2/21.
//  Copyright © 2021 Alvin Tu. All rights reserved.
//

import Foundation

struct Tweet: Decodable{
    var id: String
    var text: String
}

struct Tweets: Decodable {
    var all: [Tweet]
    
    enum CodingKeys: String, CodingKey {
        case all = "data"
    }
}


