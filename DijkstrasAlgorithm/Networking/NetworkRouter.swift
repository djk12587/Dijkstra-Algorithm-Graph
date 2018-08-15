//
//  NetworkRouter.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkEncoding
{
    case json, url
}

protocol NetworkRouter: URLRequestConvertible
{
    var baseURL: String { get }
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var encoding: NetworkEncoding { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension NetworkRouter
{
    var method: Alamofire.HTTPMethod
    {
        return .get
    }

    var encoding: NetworkEncoding
    {
        return .url
    }

    var parameters: [String: Any]?
    {
        return nil
    }

    var headers: [String: String]?
    {
        return nil
    }

    func asURLRequest() throws -> URLRequest
    {
        let url = Foundation.URL(string: baseURL)!.appendingPathComponent(path)
        var mutableRequest = URLRequest(url: url)
        mutableRequest.httpMethod = method.rawValue

        switch encoding
        {
        case .json:
            mutableRequest = try JSONEncoding.default.encode(mutableRequest, with: parameters)
        case .url:
            mutableRequest = try URLEncoding.default.encode(mutableRequest, with: parameters)
        }

        headers?.forEach { mutableRequest.addValue($0.value, forHTTPHeaderField: $0.key) }

        return mutableRequest
    }
}

extension NetworkRouter
{
    @discardableResult
    func request<ResultType: Model>(sessionManager: SessionManager = Alamofire.SessionManager.default, completion: @escaping (Outcome<ResultType>) -> Void) -> Request
    {
        return sessionManager.request(self).validate().responseModel(completionHandler: completion)
    }

    @discardableResult
    func request<ResultType: Model>(sessionManager: SessionManager = Alamofire.SessionManager.default, completion: @escaping (Outcome<[ResultType]>) -> Void) -> Request
    {
        return sessionManager.request(self).validate().responseModels(completionHandler: completion)
    }
}
