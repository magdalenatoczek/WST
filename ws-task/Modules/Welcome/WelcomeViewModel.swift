//
//  WelcomeViewModel.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation

protocol WelcomeViewModel {
    func showDashboard()
}

final class WelcomeViewModelImpl: WelcomeViewModel {
    typealias Dependencies = Any
    
    private let coordinator: OnboardingCoordinator
    private let dependencies: Dependencies
    
    init(coordinator: OnboardingCoordinator, dependencies: Dependencies) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
    
    func showDashboard() {
        coordinator.showDashboard()
    }
}
