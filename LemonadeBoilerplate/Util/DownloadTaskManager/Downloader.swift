//
//  Downloader.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 23.11.2021.
//
import Foundation
import UIKit

protocol DownloaderActionDelegate : AnyObject {
    func didOperationsCancelled()
    func didOperationsSuccess()
    func progressChanged( _ percentage : Double)
    func didOperationsErrorOccured( _ error : Error)
}

class Downloader : NSObject {
    weak var downloaderActionDelegate : DownloaderActionDelegate?
    
    static var operationCount : Int = 2
    private var downloadOperations : [DownloadOperation] = []
    private let operationQueue : OperationQueue = {
        let queue = OperationQueue.init()
        queue.name = UUID().uuidString
        queue.maxConcurrentOperationCount = operationCount
        return queue
    }()
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
}

extension Downloader {
    func addDownloaderTask(url : URL) -> DownloadOperation {
        let request = requestItem(with: url)
        let operation : DownloadOperation = DownloadOperation(session: session, request: request)
        operationQueue.addOperation(operation)
        downloadOperations.append(operation)
        return operation
    }
    func cancelAllOperations(){
        downloadOperations.removeAll(keepingCapacity: false)
        operationQueue.cancelAllOperations()
        OperationQueue.main.cancelAllOperations()
        downloaderActionDelegate?.didOperationsCancelled()
    }
    private func requestItem(with url : URL) -> URLRequest {
        var request = Foundation.URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        request.setValue("Bearer "  , forHTTPHeaderField: "Authorization")
        request.setValue("Bearer " , forHTTPHeaderField: "session")
        request.setValue("", forHTTPHeaderField: "uuid")
        return request
    }
}


//MARK:->Operations
extension Downloader : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard !downloadOperations.isEmpty , let operation = downloadOperations.first(where: {$0.task.taskIdentifier == downloadTask.taskIdentifier })  else { return }
        operation.downloadSuccess()
        downloaderActionDelegate?.didOperationsSuccess()
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard !downloadOperations.isEmpty , let operation = downloadOperations.first(where: {$0.task.taskIdentifier == downloadTask.taskIdentifier })  else { return }
        if operation.expectedLength == nil {
            operation.expectedLength = totalBytesExpectedToWrite
            let isAvaiable = UIDevice.current.isStorageAvaliable(fileSize: totalBytesWritten)
            if !isAvaiable {
                cancelAllOperations()
            }
        }
        let percent = Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)
        downloaderActionDelegate?.progressChanged(percent)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard !downloadOperations.isEmpty , let err = error , let operation = downloadOperations.first(where: {$0.task.taskIdentifier == task.taskIdentifier }) else { return }
        operation.downloadFailed(session, task: task, didCompleteWithError: err)
        downloaderActionDelegate?.didOperationsErrorOccured(err)
        self.cancelAllOperations()
    }
}
