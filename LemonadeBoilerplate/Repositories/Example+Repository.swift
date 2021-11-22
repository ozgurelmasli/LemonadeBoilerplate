//
//  Example+Repository.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

protocol ExampleRepositoryProtocol : AnyObject {
    /**
     Example GET Request
     
     - returns: complitionHandler : @escaping (Result<ExampleModel, ProviderError>)->Void
     ```
     */
    
    func exampleRequest(complitionHandler : @escaping (Result<ExampleModel, ProviderError>)->Void)
}



class ExampleRepository : ExampleRepositoryProtocol {
    private var provider : RequestProvider<ExampleService>?
    
    init(){
        provider = .init()
    }
    deinit {
        provider = nil
    }
    
    func exampleRequest(complitionHandler: @escaping (Result<ExampleModel, ProviderError>) -> Void) {
        provider?.request(.exampleRequest
                          , decoding: ResponseModel<ExampleModel>.self
                          , responseHandler: { response in
            complitionHandler(.success(.init(id: "Example_id", name: "Example_name", description: "Example_description")))
        })
    }
}




