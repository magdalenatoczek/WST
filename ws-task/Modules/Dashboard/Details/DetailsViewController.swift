//
//  DetailsViewController.swift
//  ws-task
//
//  Created by Magdalena Toczek on 20/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {
    typealias ViewModel = DetailsViewModel
    typealias L = Localization.Details
    
    // MARK: - Properties
    
    private let bag = DisposeBag()
    private let viewModel: ViewModel
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor.accent
        return backButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = .regular16
        title.textColor = UIColor.accent
        title.text = L.title
        return title
    }()
    
    private lazy var inputDetailsView = GpsDetailsView()
    
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
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(inputDetailsView)
        view.backgroundColor = .white
        
        backButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        inputDetailsView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func bindControls() {
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.dismiss()
            })
        .disposed(by: bag)
        
        viewModel.inputSubject.subscribe(onNext: { [weak self] input in
            if let input = input {
                self?.inputDetailsView.setup(with: input)
            }
        }).disposed(by: bag)
    }
}
