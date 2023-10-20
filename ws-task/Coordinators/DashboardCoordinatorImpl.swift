//
//  DashboardCoordinator.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation
import UIKit

enum DashboardCoordinatorDestinationType {
    case details(GpsModel)
}

protocol DashboardCoordinator {
    func show(type: DashboardCoordinatorDestinationType)
    func dismiss()
}

final class DashboardCoordinatorImpl: BaseCoordinator {
    typealias Dependencies = HasJsonDecoder & HasFilesManager
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    override func start() {
        let viewModel = DashboardViewModelImpl(coordinator: self, dependencies: dependencies)
        let viewController = DashboardViewController(viewModel: viewModel)
        self.navigationController.setViewControllers([viewController], animated: true)
    }
}

extension DashboardCoordinatorImpl: DashboardCoordinator {
    func show(type: DashboardCoordinatorDestinationType) {
        switch type {
        case .details(let item):
            let viewModel = DetailsViewModelImpl(coordinator: self, dependencies: dependencies, item: item)
            let viewController = DetailsViewController(viewModel: viewModel)
            if let sheet = viewController.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.preferredCornerRadius = 20
                    }
            self.navigationController.present(viewController, animated: true)
        }
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
    }
}
