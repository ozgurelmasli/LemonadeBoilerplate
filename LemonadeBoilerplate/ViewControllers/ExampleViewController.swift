//
//  ExampleViewController.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import LemonadeUI

class ExampleView: UIView {
    
    lazy var startMusic: LemonadeButton = {
        return .init(frame: .zero, .init(text: "Start Music", color: .systemBlue, font: .generateFont(size: 30), alignment: .center))
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(startMusic)
        startMusic.center(to: self, width: .screenWidth(24), height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ExampleViewController: BaseViewController<ExampleViewModel, ExampleView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        safeView.startMusic.addTarget(self, action: #selector(startMusicTapped), for: .touchUpInside)
    }
    @objc func startMusicTapped() {
        safeViewModel.startPlayer()
    }
}
