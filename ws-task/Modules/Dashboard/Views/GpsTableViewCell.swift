//
//  GPSpointTableViewCell.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import UIKit

final class GpsTableViewCell: UITableViewCell {
    
    static let identifier = "GpsInputTableViewCell"
    
    // MARK: - Structures
    
    struct ViewModel {
        var altitude: String
        var timestamp: String
        var distance: String
    }
    
    // MARK: - UIComponents
    
    private lazy var imageImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var altitudeView = GpsRow(type: .altitude)
    private lazy var timestampView = GpsRow(type: .timestamp)
    private lazy var distanceView = GpsRow(type: .distance)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [altitudeView, distanceView, timestampView])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layoutView()
    }
    
    // MARK: - Public implementation
    
    func setup(with viewModel: ViewModel) {
        altitudeView.setup(value: viewModel.altitude.formatToDecimalPlaces(2))
        timestampView.setup(value: viewModel.timestamp.convertToTime())
        distanceView.setup(value: viewModel.distance.convertToDistance())
    }
    
    // MARK: - Private implementation
    
    private func layoutView() {
        contentView.addSubview(stackView)
        contentView.backgroundColor = .white
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
