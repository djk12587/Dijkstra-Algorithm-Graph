//
//  Model.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation

enum ParsingError: Error
{
    case failed
    case empty
}

typealias JSON = [String: Any?]

protocol Model
{
    init(json: JSON?) throws
}

extension Model
{
    static func array<ModelType: Model>(from data: Data?) throws -> [ModelType]
    {
        guard let data = data else { throw ParsingError.failed }
        guard !data.isEmpty else { throw ParsingError.empty }

        do
        {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let jsonObjects: [ModelType] = try Self.array(from: json)

            return jsonObjects
        }
        catch
        {
            throw error
        }
    }

    static func array<ModelType: Model>(from json: Any?) throws -> [ModelType]
    {
        guard let json = json else { throw ParsingError.failed }

        var jsonObjects = [ModelType]()

        if let jsonArray = json as? [JSON]
        {
            jsonObjects = jsonArray.compactMap { (json) -> ModelType? in
                try? ModelType(json: json)
            }
        }
        else
        {
            guard let json = json as? JSON else { throw ParsingError.failed }

            if json.isEmpty
            {
                return jsonObjects
            }

            do
            {
                let jsonObject = try ModelType(json: json)
                jsonObjects.append(jsonObject)
            }
            catch
            {
                throw error
            }
        }
        return jsonObjects
    }
}
