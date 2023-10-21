//
//  DetailsViewModel.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol DetailsViewModel {
    var inputSubject: BehaviorSubject<GpsModel?> { get }
    func dismiss()
}

final class DetailsViewModelImpl: DetailsViewModel {
    
    typealias Dependencies = Any
    
    private let bag = DisposeBag()
    private let coordinator: DashboardCoordinator
    private let dependencies: Dependencies
    
    let inputSubject = BehaviorSubject<GpsModel?>(value: nil)
    
    init(coordinator: DashboardCoordinator, dependencies: Dependencies, item: GpsModel) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        self.inputSubject.onNext(item)
    }
    
    func dismiss() {
        coordinator.dismiss()
    }
}
