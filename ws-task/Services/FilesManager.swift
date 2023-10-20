//
//  FilesManager.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation
import RxSwift

protocol HasFilesManager {
    var filesManager: FilesManager { get }
}

protocol FilesManager {
    func readFile(fileName: String, type: FileType) -> Single<Data>
}

enum FileType: String {
    case json = "json"
}

final class FilesManagerImpl: FilesManager {
    
    enum FileManagerError: Error {
        case fileNotFound
    }
    
    func readFile(fileName: String, type: FileType) -> Single<Data> {
        return Single.create { single -> Disposable in
            guard let path = Bundle.main.path(forResource: fileName, ofType: type.rawValue) else { single(.failure(FileManagerError.fileNotFound))
                return Disposables.create()
            }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                single(.success(data))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
