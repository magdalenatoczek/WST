//
//  AppCoordinator.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//
import UIKit

enum AppCoordinatorDestinationType {
    case onboarding
    case dashboard
}

protocol AppCoordinator {
    func show(type: AppCoordinatorDestinationType)
}

final class AppCoordinatorImpl: BaseCoordinator {
    
    typealias Dependencies = HasJsonDecoder & HasFilesManager
    
    private var dependencies: Dependencies
    private var window: UIWindow?
    
    init(window: UIWindow?, dependendies: Dependencies) {
        self.window = window
        self.dependencies = dependendies
    }
    
    override func start() {
        self.navigationController.navigationBar.isHidden = true
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        show(type: .onboarding)
    }
}
  
extension AppCoordinatorImpl: AppCoordinator {
    
    func show(type: AppCoordinatorDestinationType) {
        removeChildCoordinators()
        let coordinator: Coordinator
            switch type {
            case .onboarding:
                coordinator = OnboardingCoordinatorImpl(dependencies: dependencies)
            case .dashboard:
                coordinator = DashboardCoordinatorImpl(dependencies: dependencies)
            }
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}
