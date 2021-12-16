//
//  CustomPlayerController.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 12.12.2021.
//
import SDWebImage
import LemonadeUI
import AVKit

enum CustomPlayerUIState {
    case fullScreen
    case minimal
}

class CustomPlayerView: UIView {
    private(set) var UIState: CustomPlayerUIState = .minimal
    var config: CustomPlayerControllerConfig? {
        didSet {
            if config != nil {
                UIState = config!.miniPlayerEnabled ? .minimal : .fullScreen
            }
            configureUI()
        }
    }
    
    private lazy var playerImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.opacity = 0.0
        return imageView
    }()
    
    private lazy var titleLabel: LemonadeLabel = {
        return .init(frame: .zero, .init(text: "", color: .white, font: .generateFont(size: 16), alignment: .left))
    }()
    private lazy var artistLabel: LemonadeLabel = {
        return .init(frame: .zero, .init(text: "", color: .white.withAlphaComponent(0.7), font: .generateFont(size: 14), alignment: .left))
    }()
    
    private lazy var playerSlider: LemonadeSlider = {
        let sliderconfig = LemonadeSliderConfig.init(sliderColor: .white.withAlphaComponent(0.5)
                                                     , thumbConfig: .init(color: .white, value: 0, height: 30)
                                                     , maskedViewThumbsBetweenThumbs: .init(frame: .zero, color: .init(backgroundColor: .white)) , isThumbsLabelsTrackProgress: false)
        let slider: LemonadeSlider = .init(frame: .zero, sliderconfig)
        return slider
    }()
    
    lazy var volumeSlider: LemonadeSlider = {
        let sliderConfig = LemonadeSliderConfig.init(sliderColor: .white.withAlphaComponent(0.3)
                                                     , startValue: 0
                                                     , endValue: 10
                                                     , sliderHeight: 4
                                                     , thumbConfig: .init(color: .white, value: 5, height: 30)
                                                     , maskedViewThumbsBetweenThumbs: .init(frame: .zero, color:.init(backgroundColor: .white.withAlphaComponent(0.6))))
        let slider: LemonadeSlider = .init(frame: .zero, sliderConfig)
        return slider
    }()
    
    private lazy var toggleStateButton: LemonadeButton = {
        let button: LemonadeButton = .init(frame: .zero, color: .init(backgroundColor: .clear))
        button.setImage(.init(systemName: "chevron.down"), for: .normal)
        button.tintColor = .white.withAlphaComponent(0.7)
        button.onClick(target: self, #selector(toggleUI))
        return button
    }()
    
    lazy var closeButton: LemonadeButton = {
        let button: LemonadeButton = .init(frame: .zero, color: .init(backgroundColor: .clear))
        button.setImage(.init(systemName: "xmark"), for: .normal)
        button.tintColor = .white.withAlphaComponent(0.7)
        return button
    }()
    lazy var playButton: LemonadeButton = {
        let button: LemonadeButton = .init(frame: .zero)
        button.setImage(.init(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    lazy var controlButtons: PlayerControllerUI = {
        return .init()
    }()

    override init(frame: CGRect) {
        super.init(frame: .init(x: 0, y: .screenHeight(), width: .screenWidth(), height: 0))
    }
    
    private func configureUI() {
        if config == nil { return }
        invalidateLayout()
        configureBaseUI()
        
        UIState == .fullScreen ? configureFullScreen() : configureMinimalScreen()
    }
    
    func invalidateLayout() {
        subviews.forEach { subView in
            subView.removeFromSuperview()
        }
    }
    
    func configureBaseUI() {
        backgroundColor = .black
        
        addSubview(closeButton)
        closeButton.top(self, equalTo: .top, constant: 20, safeArea: true)
        closeButton.right(self, equalTo: .right, constant: -24)
        closeButton.widthAndHeight(constant: 30)
        
        if !config!.miniPlayerEnabled { return }
        addSubview(toggleStateButton)
        toggleStateButton.top(self, equalTo: .top, constant: 20, safeArea: true)
        toggleStateButton.left(self, equalTo: .left, constant: 24)
        toggleStateButton.width(constant: 30)
        toggleStateButton.height(constant: 22)
    }
    
    func configureFullScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2) {
                self.frame = .init(x: 0, y: 0, width: .screenWidth(), height: .screenHeight())
            }
        }
        toggleStateButton.setImage(.init(systemName: "chevron.down"), for: .normal)
        
        addSubview(playerImageView)
        playerImageView.top(closeButton, equalTo: .bottom, constant: 20)
        playerImageView.centerX(self, equalTo: .centerX)
        playerImageView.widthAndHeight(self, equalTo: .width, multiplier: 0.8)
        
        addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.top(playerImageView, equalTo: .bottom, constant: 10)
        titleLabel.leftAndRight(self, constant: 24)
        
        addSubview(artistLabel)
        artistLabel.textAlignment = .center
        artistLabel.leftAndRight(self, constant: 24)
        artistLabel.top(titleLabel, equalTo: .bottom, constant: 10)
        
        addSubview(playerSlider)
        playerSlider.width(self, equalTo: .width, multiplier: 0.8)
        playerSlider.centerX(self, equalTo: .centerX, constant: -12)
        playerSlider.top(artistLabel, equalTo: .bottom, constant: 20)
        playerSlider.height(constant: 7)
        
        addSubview(controlButtons)
        controlButtons.leftAndRight(self, constant: 24)
        controlButtons.height(constant: 50)
        controlButtons.top(playerSlider, equalTo: .bottom, constant: 20)
        
        addSubview(volumeSlider)
        volumeSlider.width(self, equalTo: .width, multiplier: 0.8)
        volumeSlider.centerX(self, equalTo: .centerX, constant: -12)
        volumeSlider.bottom(self, equalTo: .bottom, constant: -20, safeArea: true)
        volumeSlider.height(constant: 7)
        
    }
    
    func configureMinimalScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2) {
                self.frame = .init(x: 0, y: .screenHeight() - 150, width: .screenWidth(), height: 150)
            }
        }
        
        toggleStateButton.setImage(.init(systemName: "chevron.up"), for: .normal)
        
        addSubview(playerImageView)
        playerImageView.left(self, equalTo: .left, constant: 24)
        playerImageView.top(toggleStateButton, equalTo: .bottom, constant: 5)
        playerImageView.widthAndHeight(self, equalTo: .height, multiplier: 0.5)
        
        addSubview(titleLabel)
        titleLabel.textAlignment = .left
        titleLabel.centerY(playerImageView, equalTo: .centerY, constant: -10)
        titleLabel.left(playerImageView, equalTo: .right, constant: 10)
        titleLabel.right(self, equalTo: .right)
        
        addSubview(artistLabel)
        artistLabel.textAlignment = .left
        artistLabel.left(playerImageView, equalTo: .right, constant: 10)
        artistLabel.top(titleLabel, equalTo: .bottom)
        artistLabel.right(self, equalTo: .right)
        
        addSubview(playButton)
        playButton.right(self, equalTo: .right, constant: -24)
        playButton.centerY(self, equalTo: .centerY)
        playButton.widthAndHeight(constant: 50)
    }
    
    @objc func toggleUI() {
        UIState = UIState == .fullScreen ? .minimal : .fullScreen
        configureUI()
    }
    
    func reloadUI(playableSource: Playable) {
        UIView.animate(withDuration: 0.5) {
            self.playerImageView.layer.opacity = 0.0
        }
        playerImageView.sd_setImage(with: .init(string: playableSource.source.imageURL), completed: { [weak self] _, _, _ ,_ in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self?.playerImageView.layer.opacity = 1.0
                }
            }
        })
        titleLabel.text = playableSource.name
        artistLabel.text = playableSource.creator?.name
    }
    
    func didPlayOrPaused(isPlaying: Bool) {
        controlButtons.changePlayPause(isPlaying: isPlaying)
        playButton.setImage(.init(systemName: isPlaying ? "pause.fill" : "play.fill"), for: .normal)
    }
    
    func moveSlider(value: CGFloat) {
        playerSlider.moveFirstThumb(value: value)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class CustomPlayerController: BaseViewController<CustomPlayerViewModel, CustomPlayerView> {
    
    private var player: CustomPlayer?
    private var totalDuration: Float64 = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeView.config = safeViewModel.config
        safeView.reloadUI(playableSource: safeViewModel.currentPlayableSource)
        safeView.controlButtons.actionDelegate = self
        safeView.playButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        safeView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        safeView.volumeSlider.delegate = self
        configurePlayer()
    }
    private func configurePlayer() {
        player = .init(safeViewModel.sourceURLs, currentIndex: safeViewModel.currentIndex)
        player?.customPlayerActionDelegate = self
    }
    @objc func playPauseTapped() {
        (player?.isPlaying ?? false) ? player?.pause() : player?.play()
    }
    @objc func closeButtonTapped() {
        player = nil
        safeViewModel.closePlayer()
    }
}
extension CustomPlayerController: PlayerControllerUIDelegate {
    func didNext() {
        DispatchQueue.main.async {
            self.safeViewModel.next()
            self.safeView.reloadUI(playableSource: self.safeViewModel.currentPlayableSource)
        }
        player?.next()
    }
    
    func didNext15() {
        player?.slide(action: .next15Seconds)
    }
    
    func didPrev() {
        DispatchQueue.main.async {
            self.safeViewModel.prev()
            self.safeView.reloadUI(playableSource: self.safeViewModel.currentPlayableSource)
        }
        player?.previous()
    }
    
    func didPrev15() {
        player?.slide(action: .prev15Seconds)
    }
    
    func didPlayPause() {
        DispatchQueue.main.async {
            self.safeView.controlButtons.changePlayPause(isPlaying: self.player?.isPlaying ?? false)
        }
        (player?.isPlaying ?? false) ? player?.pause() : player?.play()
    }
}
extension CustomPlayerController: CustomPlayerDelegate {
    func didFinish() {
        DispatchQueue.main.async {
            self.safeViewModel.next()
            self.safeView.reloadUI(playableSource: self.safeViewModel.currentPlayableSource)
        }
    }
    
    func didPlayerPaused() {
        DispatchQueue.main.async {
            self.safeView.didPlayOrPaused(isPlaying: false)
        }
    }
    
    func didPlayerPlayed() {
        DispatchQueue.main.async {
            self.safeView.didPlayOrPaused(isPlaying: true)
        }
    }
    
    func didDurationChanged(_ second: Int, _ minute: Int) {
        if safeView.UIState == .minimal { return }
        let duration = (minute * 60) + second
        if totalDuration != 0.0 && duration != 0 {
            let per: CGFloat = CGFloat(Double((duration * 100)) / totalDuration)
            safeView.moveSlider(value: per > 100 ? 100 : per)
        }
    }
    
    func didTotalDurationChanged(_ duration: Float64) {
        totalDuration = duration
    }
    
    func didPlayerStateChanged(_ state: AVKeyValueStatus) {
        switch state {
        case .loaded:
            player?.play()
        case .failed:
            print("Failed")
        default:
            break
        }
    }
}
extension CustomPlayerController: LemonadeSliderDelegate {
    func thumbChanged(_ value: CGFloat, _ slider: LemonadeSlider, thumbIndex: Int) {
        player?.volume = Float(value / 10)
    }
}
