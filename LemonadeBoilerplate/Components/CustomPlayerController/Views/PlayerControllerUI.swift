//
//  PlayerControllerUI.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 13.12.2021.
//
import LemonadeUI

protocol PlayerControllerUIDelegate: AnyObject {
    func didNext()
    func didNext15()
    func didPrev()
    func didPrev15()
    func didPlayPause()
}

class PlayerControllerUI: UIView {
    
    weak var actionDelegate: PlayerControllerUIDelegate?
    
    private lazy var next15Button: UIButton = {
        let button: UIButton = .init()
        button.setImage(.init(systemName: "goforward.15"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var prev15Button: UIButton = {
        let button: UIButton = .init()
        button.setImage(.init(systemName: "gobackward.15"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(.init(systemName: "forward.frame.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    private lazy var prevButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(.init(systemName: "backward.frame.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(.init(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [
            prevButton, prev15Button, playButton, next15Button, nextButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.fill2SuperView()
        
        for ( index, button ) in [prevButton, prev15Button, playButton, next15Button, nextButton].enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func buttonTapped(button: UIButton) {
        button.tag == 0
        ? actionDelegate?.didPrev()
        : button.tag == 1
        ? actionDelegate?.didPrev15()
        : button.tag == 2
        ? actionDelegate?.didPlayPause()
        : button.tag == 3
        ? actionDelegate?.didNext15()
        : actionDelegate?.didNext()
    }
    
    func changePlayPause(isPlaying: Bool) {
        playButton.setImage(.init(systemName: isPlaying ? "pause.fill" : "play.fill"), for: .normal)
    }
}
