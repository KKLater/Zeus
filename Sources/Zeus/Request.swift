//
//  Requets.swift
//  Zeus
//
//  Created by 罗树新 on 2023/7/1.
//

import Foundation
import Alamofire

/// 实例请求对象
public class Request {
    
    /// 请求协议配置
    public private(set) var requestOptions: any Requestable
    
    /// 初始化请求
    /// - Parameters:
    ///   - requestOptions: 请求协议配置，遵循 Requestable
    ///   - token: 请求取消token
    public init(requestOptions: any Requestable, token: String? = nil) {
        self.requestOptions = requestOptions
        self.path = requestOptions.readPath()
        self.url = requestOptions.readUrl()
        self.method = requestOptions.method()
        self.parameters = requestOptions.parameters()
        self.headers = requestOptions.readHeaders()
        self.timeoutInterval = requestOptions.readTimeoutInterval()
        self.requestHandlers = requestOptions.requestHandlers()
        self.responseHandlers = requestOptions.responseHandlers()
        self.token = token ?? UUID().uuidString
    }
    
    /// 请求取消 token
    public var token: String
    
    /// 请求 URL
    public var url: String
    
    /// 请求路径
    public var path: String
    
    /// 请求方法
    public var method: Method
    
    /// 请求参数
    public var parameters: Parameters?
    
    /// 请求头
    public var headers: Headers
    
    /// 请求超时时长
    public var timeoutInterval: TimeInterval
    
    /// 请求拦截器
    public var requestHandlers: [RequestHandleable]
    
    /// 请求结果拦截
    public var responseHandlers: [ResponseHandleable]
    
    /// 请求结束回调
    public var completion: ((Result<Response<Data>, Error>) -> Void)?
    
    /// 实际请求
    public internal(set) var dataRequest: DataRequest?
    
    /// 发起请求
    /// - Parameter completion: 请求结束回调
    public func execute(completion: @escaping (Result<Response<Data>, Error>) -> Void) {
        
        if let error = requestOptions.validate() {
            completion(.failure(error))
            return
        }
        
        if let result = handle(self) {
            completion(result)
            return
        }
        
        self.completion = completion
        Session.shared.execute(request: self) { [weak self] result in
            guard let sSelf = self else { return }
            let dataResult = sSelf.handle(result)
            guard let resultKey = sSelf.requestOptions.resultKey() else {
                completion(dataResult)
                return
            }
            
            switch dataResult {
            case .success(let response):
                do {
                    guard let data = response.data else {
                        completion(.failure(ZeusError.ResponseError.parsingKeysFailed(resultKey)))
                        return
                    }
                    
                    let newData = try data.zeus.mapping(by: resultKey)
                    let dataResponse = Response<Data>(result: newData,
                                                      data: response.data,
                                                      request: response.request,
                                                      urlRequest: response.urlRequest,
                                                      urlResponse: response.urlResponse,
                                                      metrics: response.metrics,
                                                      serializationDuration: response.serializationDuration)
                    completion(.success(dataResponse))
                    
                } catch {
                    completion(.failure(error))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// 拦截请求
    /// - Parameter request: 请求实例
    /// - Returns: 拦截请求后，返回结果
    private func handle(_ request: Request) -> Result<Response<Data>, Error>? {
        for handler in requestHandlers {
            if let result = handler.handle(request) {
                return result
            }
        }
        return nil
    }
    
    /// 拦截请求结果回调
    /// - Parameter response: 请求结果
    /// - Returns: 拦截请求响应，返回结果
    private func handle(_ response: Result<Response<Data>, Error>) -> Result<Response<Data>, Error> {
        var result: Result<Response<Data>, Error> = response
        for handle in responseHandlers {
            if let callBackResult = handle.handle(result) {
                result = callBackResult
            }
            
            if case .failure(_) = result {
                return result
            }
        }
        
        return result
    }
    
    deinit {
        print(self)
        print("Request deinit")
    }
}

public class RequestManager {
    public static let shared = RequestManager()
    
    private var requests = [String: Request]()
    
    public func cancelRequest(for token: String) {
        var requests = self.requests
        if let _ = requests[token] {
            requests.removeValue(forKey: token)
            self.requests = requests
        }
    }
    
    public func cancelAll() {
        var requests = self.requests
        
        Session.shared.cancelAll()
        requests.removeAll()
        self.requests = requests
    }
    
    @discardableResult
    public func retryRequest(for token: String) -> Bool {
        guard let request = requests[token] else {
            return false
        }
        if let completion = request.completion {
            request.execute(completion: completion )
            return true
        }
        
        return false
    }
}

extension RequestManager {
    
    func save(request: Request, for cancelToken: String) {
        var requests = self.requests
        if requests[cancelToken] != nil {
            return
        }
        requests[cancelToken] = request
        self.requests = requests
    }
}
