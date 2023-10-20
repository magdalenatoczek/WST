//
//  DashboardCoordinatorMock.swift
//  ws-taskTests
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation
@testable import ws_task

class DashboardCoordinatorMock: DashboardCoordinator {
    var showDetailsInvoke = false
    var dismissInvoke = false
    
    func show(type:DashboardCoordinatorDestinationType) {
        switch type {
        case .details(_):
            showDetailsInvoke = true
        }
    }
    
    func dismiss() {
        dismissInvoke = true
    }
}
