//
//  BaseService.swift
//  Tanqin
//
//  Created by HaKT on 02/10/2023.
//

import Foundation
import Alamofire
import RxSwift

// Can use Reachability to notification when change status network

class BaseService {
    static var isReachable: Bool {
        return NetworkReachabilityManager.default!.isReachable
    }
    
    // can save base url to remote config firebase
    private let baseURL = "https://raw.githubusercontent.com/" // Github
    
    private var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        
        // if need access token
//        header.add(name: "Authorization", value: "Bearer \(accessToken)")
        return headers
    }
    
    private var alamofireManager: Alamofire.Session
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        alamofireManager = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: Decodable>(_ path: String,
                               _ method: HTTPMethod,
                               parameters: Parameters? = nil,
                               of: T.Type,
                               encoding: ParameterEncoding = URLEncoding.default,
                               success: @escaping (T) -> Void,
                               failure: @escaping (_ code: Int, _ message: String) -> Void) {
        if !BaseService.isReachable {
            failure(0, "Network unavailble!")
        } else {
            let url = path.starts(with: "http") ? path : "\(baseURL)\(path)"
            print("URLRequest: ", url)
            alamofireManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(data):
                        success(data)
                    case let .failure(error):
                        print(error.localizedDescription)

                        let code = error.responseCode ?? 0
                        let message = error.failureReason ?? ""
                        failure(code, message)
                    }
                }
        }
    }
}

extension BaseService {
    func rxRequest<T: Decodable>(_ path: String,
                                 _ method: HTTPMethod,
                                 parameters: Parameters? = nil,
                                 of: T.Type,
                                 encoding: ParameterEncoding = URLEncoding.default) -> Single<T> {
        Single<T>.create { single in
            self.request(path, method, parameters: parameters, of: of, encoding: encoding, success: { data in
                single(.success(data))
            }, failure: { code, message in
                single(.failure(AppError(code: code, message: message)))
            })
            
            return Disposables.create()
        }
    }
}
