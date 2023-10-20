//
//  DashboardViewModelTests.swift
//  ws-taskTests
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import XCTest
import RxBlocking
@testable import ws_task

final class DashboardViewModelTests: XCTestCase {
    
    var viewModel: DashboardViewModel!
    var coordinator: DashboardCoordinatorMock!
    
    struct Dependencies: DashboardViewModelImpl.Dependencies {
        var filesManager: FilesManager = FilesManagerImpl()
        var jsonDecoder: JsonDecoder = JsonDecoderImpl()
    }

    override func setUpWithError() throws {
        coordinator = DashboardCoordinatorMock()
        viewModel = DashboardViewModelImpl(coordinator: coordinator, dependencies: Dependencies(), pathToFile: "test")
    }

    func testGetItems() throws {
        XCTAssertEqual(try viewModel.currentValueObservable.toBlocking().first()?.count, 7)
        viewModel.getItems(for: .all)
        XCTAssertEqual(try viewModel.currentValueObservable.toBlocking().first()?.count, 7)
        viewModel.getItems(for: .filtered)
        XCTAssertEqual(try viewModel.currentValueObservable.toBlocking().first()?.count, 4)
    }
    
    func testShowDetails() throws {
        XCTAssertEqual(coordinator.showDetailsInvoke, false)
        viewModel.showSelectedItem(for: GpsModel(longitude: "", altitude: "", timestamp: "", latitude: "", accuracy: "", distance: ""))
        XCTAssertEqual(coordinator.showDetailsInvoke, true)
    }
}
