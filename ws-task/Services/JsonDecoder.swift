//
//  JsonDecoder.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import RxSwift
import Foundation

protocol HasJsonDecoder {
    var jsonDecoder: JsonDecoder { get }
}

protocol JsonDecoder {
    func decode<T: Decodable>(data: Data, type: T.Type) -> Single<T>
}

final class JsonDecoderImpl: JsonDecoder {
    
    func decode<T: Decodable>(data: Data, type: T.Type) -> Single<T> {
        return Single.create { single -> Disposable in
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(type, from: data)
                single(.success(decodedData))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
