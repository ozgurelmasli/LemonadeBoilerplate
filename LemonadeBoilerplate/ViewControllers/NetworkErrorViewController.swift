//
//  NetworkErrorViewController.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import LemonadeUI

protocol NetworkErrorActionDelegate : AnyObject {
    /// Try again button tapped action
    func didTryAgainButtonTapped()
}

class NetworkErrorView : UIView {
    weak var networkViewDelegate : NetworkErrorActionDelegate?
    
    private lazy var icon : UIImageView = {
        let imageView : UIImageView = .init(image: .init(systemName: "wifi.exclamationmark")?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGreen
        return imageView
    }()
    
    private lazy var descriptionLabel : LemonadeLabel = {
        return .init(frame: .zero, .init(text: "No internet connection", color: .black, font: .generateFont(size: 30), alignment: .center))
    }()
    
    private lazy var tryAgainButton : LemonadeButton = {
        let button : LemonadeButton =  .init(frame: .zero, .init(text: "Try again.", color: .white, font: .generateFont(size: 20), alignment: .center))
        button.radius(.init(radius: 12))
        button.backgroundColor = .systemGreen
        button.onClick(target: self, #selector(tryAgainButtonTapped))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    private func configureUI(){
        backgroundColor = .white
        
        addSubview(icon)
        icon.center(to: self)
        icon.widthAndHeight(self, equalTo: .width , multiplier: 0.5)
        
        addSubview(descriptionLabel)
        descriptionLabel.top(icon, equalTo: .bottom)
        descriptionLabel.centerX(self, equalTo: .centerX)
        descriptionLabel.width(self, equalTo: .width)
        
        addSubview(tryAgainButton)
        tryAgainButton.leftAndRight(self , constant: 24)
        tryAgainButton.bottom(self, equalTo: .bottom , safeArea: true)
        tryAgainButton.height(constant: 45)
    }
    @objc private func tryAgainButtonTapped(){
        self.networkViewDelegate?.didTryAgainButtonTapped()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


class NetworkErrorVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func loadView() {
        super.loadView()
        view = NetworkErrorView()
    }
}
