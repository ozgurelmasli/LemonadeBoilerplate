//
//  DownloadOperation.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 23.11.2021.
//

import Foundation

class DownloadOperation : AsynchronousOperation {
    public var task: URLSessionTask!
    public var expectedLength : Int64? = nil
    
    init(session : URLSession , request : URLRequest) {
        task = session.downloadTask(with: request)
        super.init()
    }
    
    override func cancel() {
        task.cancel()
        super.cancel()
    }
    override func main() {
        task.resume()
    }
}

extension DownloadOperation {
    
    func downloadSuccess(){
        completeOperation()
    }
    func downloadFailed(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error?.localizedDescription ?? "")
        completeOperation()
    }
    
}
