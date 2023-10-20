//
//  WsDependencies.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation

final class WsDependencies: AppCoordinatorImpl.Dependencies {
    var filesManager: FilesManager = FilesManagerImpl()
    var jsonDecoder: JsonDecoder = JsonDecoderImpl()
}
