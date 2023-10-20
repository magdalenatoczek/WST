//
//  Double+Ext.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation

extension Double {
    
    func roundedTo(place: Double) -> Double {
        let multiplier = pow(10.0, place)
        return (self * multiplier).rounded() / multiplier
    }
}
