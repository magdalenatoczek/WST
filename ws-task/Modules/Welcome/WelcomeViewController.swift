//
//  WelcomeViewController.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WelcomeViewController: UIViewController {
    
    typealias ViewModel = WelcomeViewModel
    typealias L = Localization.Welcome
    
    // MARK: - Properties
    
    private let bag = DisposeBag()
    private let viewModel: ViewModel
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.accent
        button.setTitleColor(UIColor.text, for: .normal)
        button.layer.cornerRadius = 24
        button.titleLabel?.font = .bold16
        button.setTitle(L.title, for: .normal)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "map")
        return imageView
    }()
    
    private lazy var lineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "route")
        return imageView
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
    }
    
    // MARK: - View
    
    private func layoutView() {
        view.addSubview(imageView)
        view.addSubview(lineImageView)
        view.addSubview(mainButton)
        
        imageView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        lineImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        mainButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(108)
            $0.height.equalTo(48)
        }
    }
    
    private func bindControls() {
        mainButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.showDashboard()
        }).disposed(by: bag)
    }
}
