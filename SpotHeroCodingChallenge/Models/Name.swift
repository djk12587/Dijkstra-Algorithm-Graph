//
//  Name.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation

struct Name: Model
{
    var name: String

    init(json: JSON?) throws
    {
        guard let json = json, let name = json["name"] as? String else { throw ParsingError.failed }

        self.name = name
    }
}
