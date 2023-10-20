//
//  GPSpathPoint.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation

struct GpsModel: Decodable, Hashable, Equatable {
    var longitude: String
    var altitude: String
    var timestamp: String
    var latitude: String
    var accuracy: String
    var distance: String
}
