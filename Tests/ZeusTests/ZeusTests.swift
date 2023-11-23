import XCTest
@testable import Zeus

final class ZeusTests: XCTestCase {
    func testGetJsonRequest() throws {
        expectation(timeout: 20, description: "testSequentialRequestsOptions") { expectation in
            let id = "100"
            let token = "KNSkjdnjjasdasjkwklasdan"
            
            let getRequest = GetRequest(id: id, token: token)
            getRequest.responseJson { result in
                switch result {
                case .success(let success):
                    print(success)
                    
                case .failure(let failure):
                    print(failure)
                }
                
                guard case let .success(getRespond) = result else {
                    XCTAssert(false, "Get Request Failed")
                    return
                }
                
                let getRespondResult = getRespond
                print("Get Result: \(getRespondResult)")
                XCTAssertNotNil(getRespondResult, "Get Request Failed")
                expectation.fulfill()
            }
        }
    }
        
        
    func testGetDataRequest() throws {
        expectation(timeout: 20, description: "testSequentialRequestsOptions") { expectation in
            let id = "100"
            let token = "KNSkjdnjjasdasjkwklasdan"
            
            let getRequest = GetRequest(id: id, token: token)
            getRequest.responseData { result in
                switch result {
                case .success(let success):
                    print(success)
                    
                case .failure(let failure):
                    print(failure)
                }
                
                guard case let .success(getRespond) = result else {
                    XCTAssert(false, "Get Request Failed")
                    return
                }
                
                let getRespondResult = getRespond
                print("Get Result: \(getRespondResult)")
                XCTAssertNotNil(getRespondResult, "Get Request Failed")
                expectation.fulfill()
            }
        }
    }
       
    func testGetDecodeRequest() throws {
        expectation(timeout: 20, description: "testSequentialRequestsOptions") { expectation in
            let id = "100"
            let token = "KNSkjdnjjasdasjkwklasdan"
            
            let getRequest = GetRequest(id: id, token: token)
            getRequest.responseDecodable { result in
                switch result {
                case .success(let success):
                    print(success)
                    
                case .failure(let failure):
                    print(failure)
                }
                
                guard case let .success(getRespond) = result else {
                    XCTAssert(false, "Get Request Failed")
                    return
                }
                
                let getRespondResult = getRespond.result
                print("Get Result: \(getRespondResult)")
                XCTAssertNotNil(getRespondResult, "Get Request Failed")
                
                let getArgs = getRespondResult.args
                XCTAssertNotNil(getArgs, "Get Request Failed")
                let getId = getArgs.id
                let getToken = getArgs.token
                
                XCTAssertNotNil(getId, "Get Request Failed, get id is nil")
                XCTAssertNotNil(getToken, "Get Request Failed, get token is nil")
                expectation.fulfill()
            }
        }
    }
    
    func testPostJsonRequest() throws {
        expectation(timeout: 20, description: "testSequentialRequestsOptions") { expectation in
            let id = "100"
            let token = "KNSkjdnjjasdasjkwklasdan"
            
            let postRequest = PostRequest(id: id, token: token)
            postRequest.responseJson { result in
                switch result {
                case .success(let success):
                    print(success)
                    
                case .failure(let failure):
                    print(failure)
                }
                
                guard case let .success(getRespond) = result else {
                    XCTAssert(false, "Post Request Failed")
                    return
                }
                
                let getRespondResult = getRespond
                print("Post Result: \(getRespondResult)")
                XCTAssertNotNil(getRespondResult, "Post Request Failed")
                expectation.fulfill()
            }
        }
    }
        
        
    func testPostDataRequest() throws {
        expectation(timeout: 20, description: "testSequentialRequestsOptions") { expectation in
            let id = "100"
            let token = "KNSkjdnjjasdasjkwklasdan"
            
            let postRequest = PostRequest(id: id, token: token)
            postRequest.responseData { result in
                switch result {
                case .success(let success):
                    print(success)
                    
                case .failure(let failure):
                    print(failure)
                }
                
                guard case let .success(getRespond) = result else {
                    XCTAssert(false, "Post Request Failed")
                    return
                }
                
                let getRespondResult = getRespond
                print("Post Result: \(getRespondResult)")
                XCTAssertNotNil(getRespondResult, "Post Request Failed")
                expectation.fulfill()
            }
        }
    }
       
    func testPostDecodeRequest() throws {
        expectation(timeout: 20, description: "testSequentialRequestsOptions") { expectation in
            let id = "100"
            let token = "KNSkjdnjjasdasjkwklasdan"
            
            let postRequest = PostRequest(id: id, token: token)
            postRequest.responseDecodable  { result in
                switch result {
                case .success(let success):
                    print(success)
                    
                case .failure(let failure):
                    print(failure)
                }
                
                guard case let .success(postRespond) = result else {
                    XCTAssert(false, "Post Request Failed")
                    return
                }
                
                let postRespondResult = postRespond.result
                print("Post Result: \(postRespondResult)")
                XCTAssertNotNil(postRespondResult, "Post Request Failed")
                
                let postForm = postRespondResult.form
                XCTAssertNotNil(postForm, "Post Request Failed")
                let postFormId = postForm.id
                let postFormToken = postForm.token
                
                XCTAssertNotNil(postFormId, "Post Request Failed, get id is nil")
                XCTAssertNotNil(postFormToken, "Post Request Failed, get token is nil")
                expectation.fulfill()
            }
        }
    }
    
    
    
    func testJsonMapping() throws {
        let dictionary: [String: Any] = [
            "respCode": 200,
            "respData": [
                "id": 1,
                "name": "KK",
                "info": [
                    "card": [
                        "carId": 112,
                        "carDesc":"序号"
                    ]
                ]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        let mappingData = try data.zeus.mapping(by: "respData")
        XCTAssertNotNil(mappingData)
        do {
            let info = try data.zeus.mapping(by: "respData.info")
            XCTAssertNotNil(info)
        } catch {
            print(error)
        }
    }
}

class GetRequest: Requestable, ResponseDecodable {
    typealias ResponseType = GetResponseObject
    
    func baseUrl() -> String {
        "https://httpbin.org"
    }
    
    func path() -> String {
        "/get"
    }
    
    func method() -> Zeus.Method {
        return .get
    }
    
    var id: String
    var token: String
    
    init(id: String, token: String) {
        self.id = id
        self.token = token
    }
    
    deinit {
        print("Get Request Deinit")
    }
}

class PostRequest: Requestable, ResponseDecodable {
    typealias ResponseType = PostResponseObject
    
    func baseUrl() -> String {
        "https://httpbin.org"
    }
    
    func path() -> String {
        "/post"
    }
    
    func method() -> Zeus.Method {
        return .post
    }
    
    var id: String
    var token: String
    
    init(id: String, token: String) {
        self.id = id
        self.token = token
    }
    deinit {
        print("Post Request Deinit")
    }
}


struct GetResponseObject: Responseable {
    var args: GetResponseObject.Args
    
    struct Args: Responseable {
        var id: String
        var token: String
    }
}


struct PostResponseObject: Responseable {
    var form: PostResponseObject.Form
    
    struct Form: Responseable {
        var id: String
        var token: String
    }
}



extension XCTestCase {
    
    func expectation(timeout: TimeInterval,
                     description: String? = nil,
                     action: (_ expectation: XCTestExpectation) -> Void) {
        let expectation = XCTestExpectation(description: description ?? UUID().uuidString)
        action(expectation)
        wait(for: [expectation], timeout: 60)
    }
    
}
