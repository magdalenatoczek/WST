//
//  OnboardingCoordinator.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import UIKit

protocol OnboardingCoordinator {
    func showDashboard()
}

final class OnboardingCoordinatorImpl: BaseCoordinator {
    typealias Dependencies = HasJsonDecoder & HasFilesManager
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    override func start() {
        let viewModel = WelcomeViewModelImpl(coordinator: self, dependencies: dependencies)
        let viewController = WelcomeViewController(viewModel: viewModel)
        self.navigationController.setViewControllers([viewController], animated: true)
    }
}

extension OnboardingCoordinatorImpl: OnboardingCoordinator {
    func showDashboard() {
        self.parentCoordinator?.didFinish(coordinator: self)
        (self.parentCoordinator as? AppCoordinator)?.show(type: .dashboard)
    }
}
