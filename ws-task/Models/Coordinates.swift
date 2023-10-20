//
//  Coordinates.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation

struct Coordinates {
    var longitude: Double
    var latitude: Double
    
    init(input: GpsModel) {
        self.longitude = Double(input.longitude) ?? 0.0
        self.latitude = Double(input.latitude) ?? 0.0
    }
}
