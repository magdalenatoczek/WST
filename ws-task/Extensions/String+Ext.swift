//
//  String+Ext.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation

extension String {
    func convertToTime() -> String {
        let minutes = Int(self) ?? 0
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return String(format: "%02d:%02d", hours, remainingMinutes)
    }
    
    func formatToDecimalPlaces(_ decimalPlaces: Int) -> String {
        let number = Double(self) ?? 0.0
        let formattedNumber = String(format: "%.\(decimalPlaces)f", number)
        return formattedNumber
    }
    
    func convertToDistance() -> String {
        let distance = Double(self) ?? 0.0
        if distance < 1 {
            let meters = Int(distance * 1000)
            return "\(meters)m"
        } else {
            let kilometers = Int(distance)
            let meters = Int((distance * 1000).truncatingRemainder(dividingBy: 1000))
            if meters == 0 {
                return "\(kilometers)km"
            } else {
                return "\(kilometers)km \(meters)m"
            }
        }
    }
}
