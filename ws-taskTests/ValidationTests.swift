//
//  ValidationTests.swift
//  ws-taskTests
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import XCTest
import MapKit
@testable import ws_task

final class ValidationTests: XCTestCase {
    
    var validation: Validation!
    
    let gps1 = GpsModel(longitude: "19.315773", altitude: "", timestamp: "", latitude: "51.893638", accuracy: "", distance: "0.000")
    let gps2 = GpsModel(longitude: "19.315780", altitude: "", timestamp: "", latitude: "51.893660", accuracy: "", distance: "0.003")
    let gps3 = GpsModel(longitude: "19.315770", altitude: "", timestamp: "", latitude: "51.893688", accuracy: "", distance: "0.006")
    let gps4 = GpsModel(longitude: "19.315731", altitude: "", timestamp: "", latitude: "51.893681", accuracy: "", distance: "0.009")

    override func setUpWithError() throws {
        validation = ValidationImpl()
    }

    func testCreateComparableModels() throws {
        let models = validation.createCompareModels(from: [gps1, gps2, gps3, gps4])
        XCTAssertEqual(models.count, 3)
        XCTAssertEqual(models, [ComparableModel(previousItem: gps1, currentItem: gps2),
                                ComparableModel(previousItem: gps2, currentItem: gps3),
                                ComparableModel(previousItem: gps3, currentItem: gps4)])
        
    }
    
    func testDistance() throws {
        let models = [ComparableModel(previousItem: gps1, currentItem: gps2),
                      ComparableModel(previousItem: gps2, currentItem: gps3),
                      ComparableModel(previousItem: gps3, currentItem: gps4)]
        
        let diffetence = models.map { validation.getDistanceDifference(for: $0 )}
        XCTAssertEqual(diffetence.count, 3)
        XCTAssertEqual(diffetence, [3.0, 3.0, 3.0])
    }

    func testFiltration() throws {
        let filteredItems = validation.filter(items: [gps1, gps2, gps3, gps4])
        XCTAssertEqual(filteredItems.first, gps1)
        XCTAssertEqual(filteredItems.count, 3)
    }
    
    func testAbsDistance() throws {
        let model = ComparableModel(previousItem: gps1, currentItem: gps2)
        XCTAssertEqual(validation.getDistanceDifference(for: model), 3.0)
        XCTAssertEqual(validation.getDistanceFromLocation(for: model), 2.4948186549843685)
        XCTAssertEqual(validation.getAbsDistanceDiference(for: model), FilteredModel(currentItem: gps2, difference: 0.5051813450156315))
    }
}
