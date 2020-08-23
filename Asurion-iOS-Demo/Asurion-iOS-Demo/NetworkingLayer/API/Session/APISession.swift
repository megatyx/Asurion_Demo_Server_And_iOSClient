//
//  APISession.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/24/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import Foundation

class APISession: NetworkRequestBuildable {
    let urlSession: URLSession
    var dataTask: URLSessionDataTask? = nil
    
    typealias Failure = (APIError) -> Void
    typealias SuccessDic = ([String:Any]) -> Void
    typealias SuccessResponse = (Data?, HTTPURLResponse)
    
    init(urlSession: URLSession = URLSession(configuration: .default), headers:[String:String]? = nil) {
        if let headers = headers {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = headers
            self.urlSession = URLSession(configuration: config)
        } else {
            self.urlSession = urlSession
        }
    }
    
    deinit {
        dataTask = nil
    }
    
    func cancelNetwork() {
        self.dataTask?.cancel()
    }
    
    func getGenericResponse(apiRoute: APIRoutes,
                            httpMethod: HTTPMethod = .get,
                            httpContent: HTTPContentType = .none,
                            parameters: Encodable? = nil,
                            urlParameters: [String:String]? = nil,
                            headers: [String:String]? = nil,
                            completion: @escaping (Result<SuccessResponse, APIError>) -> Void) {
        do {
            var request = try generateRequest(route: apiRoute.route,
                                              httpMethod: httpMethod,
                                              httpContent: httpContent,
                                              parameters: parameters,
                                              urlParameters: urlParameters,
                                              cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                              timeOutInterval: 10)
            addHeaders(headers, request: &request)
            dataTask = urlSession.dataTask(with: request) {[weak self] data, response, error in
                defer { self?.cancelNetwork() }
                if error != nil {
                    DispatchQueue.main.async { completion(.failure(APIError.unknown)) }
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async { completion(.failure(APIError.noResponse)) }
                    return
                }
                
                switch response.statusCode {
                case 200 ... 299:
                    DispatchQueue.main.async { completion(.success((data, response))) }
                default:
                    DispatchQueue.main.async {completion(.failure(APISession.handleUnexpectedResponse(response.statusCode)))}
                }
            }
            dataTask?.resume()
        } catch  {
            completion(.failure((error as? APIError) ?? APIError.unknown))
        }
    }
    
    func getData(apiRoute: APIRoutes,
                 parameters: Encodable? = nil,
                 urlParameters: [String:String]? = nil,
                 headers: [String:String]? = nil,
                 completion: @escaping (Result<Data, APIError>)->Void) {
        self.getGenericResponse(apiRoute: apiRoute,
                                parameters: parameters,
                                urlParameters: urlParameters,
                                headers: headers,
                                completion: {result in
                                    switch result {
                                    case .success(let responseData, _):
                                        guard let data = responseData else { completion(.failure(APIError.payloadParse));return}
                                        completion(.success(data))
                                    case .failure(let error):
                                        completion(.failure(error))
                                    }
        })
    }
    
    fileprivate class func handleUnexpectedResponse(_ statusCode: Int) -> (APIError) {
        switch statusCode {
        case 200 ... 299:
            return(APIError.unknown200)
        case 300 ... 399:
            return(APIError.unknown300)
        case 400:
            return(APIError.badRequest)
        case 402:
            return(APIError.unknown400)
        case 401, 403:
            return(APIError.forbidden)
        case 404:
            return(APIError.notFound)
        case 405 ... 499:
            return (APIError.unknown400)
        case 500:
            return(APIError.internalServerError)
        default:
            return(APIError.unknown)
        }
    }
}
