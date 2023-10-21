//
//  DashboardViewController.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
import SnapKit

enum GpsDataType: Int, CaseIterable {
    
    typealias Strings = Localization.Dashboard
    
    case all = 0
    case filtered = 1
    
    var title: String {
        switch self {
        case .all:
            return Strings.allTitle
        case .filtered:
            return Strings.filteredTitle
        }
    }
}

final class DashboardViewController: UIViewController {
    typealias ViewModel = DashboardViewModel
    
    // MARK: - Properties
    
    private let bag = DisposeBag()
    private let viewModel: ViewModel
    
    private let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GpsTableViewCell.self, forCellReuseIdentifier: GpsTableViewCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = true
        tableView.estimatedRowHeight = CGFloat(100)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let contentView = UIStackView(arrangedSubviews: [mapView, segmentedControl, tableView])
        contentView.axis = .vertical
        contentView.distribution = .fill
        contentView.spacing = 30
        return contentView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: GpsDataType.allCases.map { $0.title })
        segmentedControl.selectedSegmentIndex = 0
        let selectedTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.text,
                                     NSAttributedString.Key.font: UIFont.regular10]
        segmentedControl.setTitleTextAttributes(selectedTextAttribute as [NSAttributedString.Key : Any], for: .selected)
        let normalTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.text,
                                   NSAttributedString.Key.font: UIFont.regular10]
        segmentedControl.setTitleTextAttributes(normalTextAttribute as [NSAttributedString.Key : Any], for: .normal)
        segmentedControl.selectedSegmentTintColor = UIColor.accent
        return segmentedControl
    }()
    
    // MARK: - Initialization
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        bindControls()
        mapView.delegate = self
    }
 
    // MARK: - View
    
    private func layoutView() {
        view.backgroundColor = UIColor.text
        view.addSubview(scrollView)
        scrollView.addSubview(mapView)
        scrollView.addSubview(segmentedControl)
        scrollView.addSubview(tableView)
     
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        mapView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(screenHeight / 2)
            $0.top.leading.trailing.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(60)
        }
     
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(40)
            $0.height.equalTo(screenHeight)
            $0.leading.trailing.equalToSuperview().inset(60)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindControls() {
        viewModel.currentValueObservable.bind(to: tableView.rx.items(cellIdentifier: GpsTableViewCell.identifier, cellType: GpsTableViewCell.self)) { _, item, cell in
            cell.setup(with: .init(altitude: item.altitude, timestamp: item.timestamp, distance: item.distance))
        }
        .disposed(by: bag)
        
        tableView.rx.modelSelected(GpsModel.self)
            .bind(onNext: { [weak self] item in
                self?.viewModel.showSelectedItem(for: item)
            })
            .disposed(by: bag)

        viewModel.coordinatesObservable
            .map { $0.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }}
            .subscribe(onNext:  { [weak self] in
                self?.setupPolyline(with: $0)
            })
            .disposed(by: bag)
        
        segmentedControl.rx.selectedSegmentIndex
            .subscribe { [weak self] index in
                self?.viewModel.fetchItems(for: GpsDataType(rawValue: index) ?? .all)
            }
            .disposed(by: bag)
    }
    
    private func setupPolyline(with coordinates: [CLLocationCoordinate2D]) {
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let edgePadding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        mapView.addOverlay(polyline, level: .aboveLabels)
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgePadding, animated: true)
    }
}

extension DashboardViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        renderer.setColors([UIColor.accent ?? .blue], locations: [])
        renderer.lineCap = .round
        renderer.lineWidth = 3.0
    return renderer
    }
}
