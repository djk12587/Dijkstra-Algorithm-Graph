//
//  Outcome.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation
import Alamofire

enum Outcome<Value>
{
    case success(Value)
    case failure(Error)

    var value: Value?
    {
        if case .success(let theValue) = self
        {
            return theValue
        }
        return nil
    }

    var error: Error?
    {
        if case .failure(let theError) = self
        {
            return theError
        }
        return nil
    }

    var success: Bool
    {
        if case .success = self
        {
            return true
        }
        return false
    }
}

extension DataResponse
{
    var outcome: Outcome<Value>
    {
        switch result
        {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}
