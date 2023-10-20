//
//  Validation.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation
import MapKit

struct FilteredModel: Equatable {
    var currentItem: GpsModel
    var difference: Double
}

struct ComparableModel: Equatable {
    var previousItem: GpsModel
    var currentItem: GpsModel
}

protocol Validation {
    func filter(items: [GpsModel]) -> [GpsModel]
    func createCompareModels(from items: [GpsModel]) -> [ComparableModel]
    func getAbsDistanceDiference(for model: ComparableModel) -> FilteredModel
    func getDistanceDifference(for model: ComparableModel) -> Double
    func getDistanceFromLocation(for model: ComparableModel) -> Double
}

struct ValidationImpl: Validation {
    
    func filter(items: [GpsModel]) -> [GpsModel] {
        guard !items.isEmpty else { return [] }
        let comparableModels = createCompareModels(from: items)
        let models = comparableModels.map { getAbsDistanceDiference(for: $0) }
        
        let mean = models.map{ $0.difference }.reduce(0, +) / Double(models.count)
        
        var newItems = [GpsModel] ()
        newItems.append(items[0])
        
        let filteredModels = models.filter { $0.difference <= mean }
        filteredModels.forEach { newItems.append($0.currentItem) }
        
        return newItems
    }
    
     func createCompareModels(from items: [GpsModel]) -> [ComparableModel] {
        var compareModels = [ComparableModel]()
        
        for index in 0...items.count - 1 {
            let previousIndex = index - 1
            if previousIndex >= 0 {
                let compareModel = ComparableModel(previousItem: items[previousIndex], currentItem: items[index])
                compareModels.append(compareModel)
            }
        }
        return compareModels
    }

    func getAbsDistanceDiference(for model: ComparableModel) -> FilteredModel {
        let meterDistance = getDistanceDifference(for: model)
        let locationDistance = getDistanceFromLocation(for: model)
        let diff = abs(locationDistance - meterDistance)
        return FilteredModel(currentItem: model.currentItem, difference: diff)
    }
    
    func getDistanceDifference(for model: ComparableModel) -> Double {
        let previousDistance = (Double(model.previousItem.distance) ?? 0.0) * 1000
        let currentDistance = (Double(model.currentItem.distance) ?? 0.0) * 1000
        return currentDistance - previousDistance
    }
    
    func getDistanceFromLocation(for model: ComparableModel) -> Double {
        let previousLocation = CLLocation(latitude: Double(model.previousItem.latitude) ?? 0.0, longitude: Double(model.previousItem.longitude) ?? 0.0)
        let currentLocation = CLLocation(latitude: Double(model.currentItem.latitude) ?? 0.0, longitude: Double(model.currentItem.longitude) ?? 0.0)
        return currentLocation.distance(from: previousLocation)
    }
}
