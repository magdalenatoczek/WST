//
//  InputRow.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import UIKit

enum InputType {
    typealias L = Localization.Dashboard
    
    case longitude
    case altitude
    case timestamp
    case latitude
    case accuracy
    case distance
    
    var title: String {
        switch self {
        case .longitude: return L.longitudeTitle
        case .altitude: return L.altitudeTitle
        case .timestamp: return L.timestampTitle
        case .latitude: return L.latitudeTitle
        case .accuracy: return L.accuracyTitle
        case .distance: return L.distanceTitle
        }
    }
    
    var image: UIImage? {
        switch self {
        case .longitude: return UIImage(named: "longitude")
        case .altitude: return UIImage(named: "altitude")
        case .timestamp: return UIImage(named: "timestamp")
        case .latitude: return UIImage(named: "latitude")
        case .accuracy: return UIImage(named: "accuracy")
        case .distance: return UIImage(named: "distance")
        }
    }
}

final class GpsRow: UIView {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
  
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = .regular16
        title.textAlignment = .left
        title.textColor = UIColor.accent
        return title
    }()
    
    private lazy var valueLabel: UILabel = {
        let title = UILabel()
        title.font = .bold16
        title.textAlignment = .right
        title.textColor = UIColor.accent
        return title
    }()
    
    convenience init(type: InputType) {
        self.init()
        layoutView()
        imageView.image = type.image
        titleLabel.text = type.title
    }

    func setup(value: String) {
       valueLabel.text =  value
   }
    
    private func layoutView() {
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(valueLabel)
      
        imageView.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.leading.bottom.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.bottom.top.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(40)
        }
    }
}
