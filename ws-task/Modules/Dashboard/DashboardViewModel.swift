//
//  DashboardViewModel.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

protocol DashboardViewModel {
    var currentValueObservable: Observable<[GpsModel]> { get }
    var coordinatesObservable: Observable<[Coordinates]> { get }
    func showSelectedItem(for item: GpsModel)
    func fetchItems(for type: GpsDataType) 
}

final class DashboardViewModelImpl: DashboardViewModel {

    typealias Dependencies = HasJsonDecoder & HasFilesManager
    
    private let bag = DisposeBag()
    private let coordinator: DashboardCoordinator
    private let dependencies: Dependencies
    
    private var currentValueSubject: BehaviorSubject<[GpsModel]> = BehaviorSubject(value: [])
    var currentValueObservable: Observable<[GpsModel]> { currentValueSubject }
    
    private var coordinatesSubject: BehaviorSubject<[Coordinates]> = BehaviorSubject(value: [])
    var coordinatesObservable: Observable<[Coordinates]> { coordinatesSubject }
    
    private var allItemsSubject: BehaviorRelay<[GpsModel]> = BehaviorRelay(value: [])
    private var filteredItemsSubject: BehaviorRelay<[GpsModel]> = BehaviorRelay(value: [])

    init(coordinator: DashboardCoordinator, dependencies: Dependencies, pathToFile: String = "GPSpath") {
        self.coordinator = coordinator
        self.dependencies = dependencies
        getItems(from: pathToFile)
        bind()
    }
    
    func showSelectedItem(for item: GpsModel) {
        coordinator.show(type: .details(item))
    }
    
    func fetchItems(for type: GpsDataType) {
        let allItems = allItemsSubject.value
        let newValue: [GpsModel]
        switch type {
        case .all:
            newValue = allItems
        case .filtered:
            newValue = filteredItemsSubject.value
        }
        currentValueSubject.onNext(newValue)
    }
    
    private func bind() {
        currentValueSubject
            .map { $0.map { Coordinates(input: $0) } }
            .subscribe(onNext: { [weak self] in
                self?.coordinatesSubject.onNext($0)
                self?.filter()
            })
            .disposed(by: bag)
    }
    
    private func getItems(from path: String) {
        dependencies.filesManager.readFile(fileName: path, type: .json)
            .flatMap { self.dependencies.jsonDecoder.decode(data: $0, type: [GpsModel].self) }
            .subscribe(onSuccess: { [weak self] in
                self?.allItemsSubject.accept($0)
                self?.currentValueSubject.onNext($0)
            })
            .disposed(by: bag)
    }

    private func filter() {
        let validation = ValidationImpl()
        let newItems = validation.filter(items: allItemsSubject.value)
        filteredItemsSubject.accept(newItems)
    }
}



