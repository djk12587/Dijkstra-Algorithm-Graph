//
//  RandomNameApi.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation
import Alamofire

struct RandomNameApi { private init() {} }

extension RandomNameApi
{
    struct GetRandomNames: NetworkRouter
    {
        var amount: Int
        
        var baseURL: String
        {
            return "http://uinames.com/"
        }
        
        var parameters: [String : Any]?
        {
            return ["amount" : amount]
        }
        
        var path: String
        {
            return "api/"
        }
        
        var method: HTTPMethod
        {
            return .get
        }
        
        var encoding: NetworkEncoding
        {
            return .url
        }
    }
}
