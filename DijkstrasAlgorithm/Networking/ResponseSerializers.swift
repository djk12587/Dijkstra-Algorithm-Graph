//
//  ResponseSerializers.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest
{
    @discardableResult
    func responseModels<ModelType: Model>(completionHandler: @escaping (Outcome<[ModelType]>) -> Void) -> Self
    {
        return response(responseSerializer: DataRequest.modelsResponseSerializer(), completionHandler: { (response) in
            completionHandler(response.outcome)
        })
    }

    static func modelsResponseSerializer<ModelType: Model>() -> DataResponseSerializer<[ModelType]>
    {
        return DataResponseSerializer { (_, response, data, error) in
            let result = Request.serializeResponseData(response: response, data: data, error: error)

            switch result
            {
            case .success:
                do
                {
                    let serializedObjects: [ModelType] = try ModelType.array(from: data)
                    return .success(serializedObjects)
                }
                catch (let parsingError)
                {
                    return .failure(parsingError)
                }
            case .failure(let failureError):
                return .failure(failureError)
            }
        }
    }

    @discardableResult
    func responseModel<ModelType: Model>(completionHandler: @escaping (Outcome<ModelType>) -> Void) -> Self
    {
        return response(responseSerializer: DataRequest.modelResponseSerializer(), completionHandler: { (response) in
            completionHandler(response.outcome)
        })
    }

    static func modelResponseSerializer<ModelType: Model>() -> DataResponseSerializer<ModelType>
    {
        return DataResponseSerializer { (request, response, data, error) in

            let modelCollectionSerializer: DataResponseSerializer<[ModelType]> = DataRequest.modelsResponseSerializer()
            let result = modelCollectionSerializer.serializeResponse(request, response, data, error)

            switch result
            {
            case .success(let models):

                if let model = models.first
                {
                    return .success(model)
                }

                return .failure(ParsingError.failed)

            case .failure(let failureError):
                return .failure(failureError)
            }
        }
    }
}
