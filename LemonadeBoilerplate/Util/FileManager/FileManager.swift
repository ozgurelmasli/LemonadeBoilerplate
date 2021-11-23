//
//  FileManager.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 23.11.2021.
//
import Foundation


enum LocalFolder : String , CaseIterable {
    case exampleFolder = "ExampleFolder"
    
    var extensions : String {
        return ".mp3"
    }
    
    var path : URL? {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory
                                                        , FileManager.SearchPathDomainMask.userDomainMask
                                                        , true)
        guard let documentedDict = paths.first as NSString? else {return nil}
        let soundDictPath = documentedDict.appendingPathComponent("\(self.rawValue)")
        return URL(fileURLWithPath: soundDictPath)
    }
    
    var pathString : String? {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory
                                                        , FileManager.SearchPathDomainMask.userDomainMask
                                                        , true)
        guard let documentedDict = paths.first as NSString? else {return nil}
        let soundDictPath = documentedDict.appendingPathComponent("\(self.rawValue)")
        return soundDictPath
    }
}

enum FileManageServiceError : Error {
    case DELETE_ERROR
    case CREATE_FOLDER_ERROR
    case FILE_ALREADY_EXISTS
    case URL_ERROR
    case WRITE_ERROR
    case MOVE_ERROR
}

class FileManageService {
    /// Getting url depends on folder type and file name
    func fileURL( _ localFolder : LocalFolder , fileName : String) -> URL? {
        if fileName == "" {return nil}
        let filename = fileName + localFolder.extensions
        return localFolder.path?.appendingPathComponent("\(filename)")
    }
    
    /// Get status of file is exists or not
    func fileContains(_ localFolder : LocalFolder , fileName : String )->Bool{
        let fileName = fileName + localFolder.extensions
        let destinationURL = localFolder.path?.appendingPathComponent(fileName)
        let isExists = FileManager().fileExists(atPath: destinationURL?.path ?? "")
        return isExists
    }
    
    /// Deleting file depends on folder type and filename. If filename is empty string this func return directly
    func deleteFile( _ localFolder : LocalFolder , fileName : String) throws {
        if fileName == "" { return }
        guard
            let path = fileURL(localFolder, fileName: fileName)
                , fileContains(localFolder, fileName: fileName)
        else { return }
        do {
            try FileManager.default.removeItem(at: path)
        } catch { throw FileManageServiceError.DELETE_ERROR }
    }
    
    func deleteAll() throws {
        let folders : [ LocalFolder ] = LocalFolder.allCases
        try folders.forEach { folder in
            if let path = folder.pathString , FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    throw FileManageServiceError.DELETE_ERROR
                }
            }
        }
    }
    
    init(){ }
    
    /// This func directly writing data , if data already exists func will return FileManagerError type
    func write( _ data : Data
                , fileName : String
                , folder : LocalFolder
                , complitionHandler : @escaping ((Result<String ,FileManageServiceError>) -> Void)) {
        do {
            try createFolderIfIsNotExists(path: folder.pathString ?? "")
        } catch(let err) {
            complitionHandler(.failure(err as! FileManageServiceError))
        }
        if fileContains(folder, fileName: fileName) {
            complitionHandler(.failure(.FILE_ALREADY_EXISTS))
        }else {
            guard let dataDestionationURL = folder.path?.appendingPathComponent(fileName + folder.extensions) else {
                complitionHandler(.failure(.URL_ERROR))
                return
            }
            do {
                try data.write(to: dataDestionationURL, options: [.atomic])
                complitionHandler(.success(dataDestionationURL.absoluteString))
            } catch {
                complitionHandler(.failure(.WRITE_ERROR))
            }
        }
    }
    
    func move(from location : URL
              , fileName : String
              , folder : LocalFolder
              , complitionHandler : @escaping ((Result<String ,FileManageServiceError>) -> Void)) {
        do {
            try createFolderIfIsNotExists(path: folder.pathString ?? "")
        } catch(let err) {
            complitionHandler(.failure(err as! FileManageServiceError))
        }
        guard let dataDestionationURL = folder.path?.appendingPathComponent(fileName + folder.extensions) else {
            complitionHandler(.failure(.URL_ERROR))
            return
        }
        do {
            if FileManager.default.fileExists(atPath: dataDestionationURL.path) {
                try FileManager.default.removeItem(at: dataDestionationURL)
            }
            try FileManager.default.moveItem(at: location, to: dataDestionationURL)
            complitionHandler(.success(dataDestionationURL.absoluteString))
        }catch {
            complitionHandler(.failure(.MOVE_ERROR))
        }
    }
    
}

extension FileManageService {
    private func createFolderIfIsNotExists(path : String) throws {
        if !FileManager.default.fileExists(atPath: path){
            do {
                try FileManager.default.createDirectory(atPath: path , withIntermediateDirectories: true, attributes: nil)
            }catch {
                throw FileManageServiceError.CREATE_FOLDER_ERROR
            }
        }
    }
}
