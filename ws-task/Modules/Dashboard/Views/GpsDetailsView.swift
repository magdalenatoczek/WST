//
//  InputDetailsView.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import UIKit

final class GpsDetailsView: UIView {
    
    private lazy var longitudeView = GpsRow(type: .longitude)
    private lazy var altitudeView = GpsRow(type: .altitude)
    private lazy var timestampView = GpsRow(type: .timestamp)
    private lazy var latitudeView = GpsRow(type: .latitude)
    private lazy var accuracyView = GpsRow(type: .accuracy)
    private lazy var distanceView = GpsRow(type: .distance)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [longitudeView, latitudeView, altitudeView, accuracyView, distanceView, timestampView])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with input: GpsModel) {
        longitudeView.setup(value: input.longitude)
        altitudeView.setup(value: input.altitude)
        timestampView.setup(value: input.timestamp)
        latitudeView.setup(value: input.latitude)
        accuracyView.setup(value: input.accuracy)
        distanceView.setup(value: input.distance)
    }
    
    private func layoutView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
