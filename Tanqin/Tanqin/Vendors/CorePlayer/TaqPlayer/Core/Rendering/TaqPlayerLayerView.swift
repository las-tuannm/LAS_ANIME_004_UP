import UIKit
import AVKit

class TaqPlayerLayerView: UIView {
    private var bottomConstraint: NSLayoutConstraint?
    private var widthMaxConstraint: NSLayoutConstraint?
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        let fontSize = UIDevice.current.userInterfaceIdiom == .pad ? 35.0 : 20.0
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textColor = .white
        label.layer.cornerRadius = 3
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 1.0
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        return label
    }()
    
    override  class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    lazy var playerLayer: AVPlayerLayer = {
        return layer as! AVPlayerLayer
    }()
    
    /// TaqPlayer instance being rendered by renderingLayer
    weak var player: TaqPlayer!
    
    deinit {
        
    }
    
    /// Constructor
    ///
    /// - Parameters:
    ///     - player: TaqPlayer instance to render.
    init(with player: TaqPlayerView) {
        super.init(frame: CGRect.zero)
        playerLayer.player = player.player
        
        addSubview(subtitleLabel)
        
        subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        subtitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        bottomConstraint = subtitleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint?.isActive = true
        
        widthMaxConstraint = subtitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 500)
        widthMaxConstraint?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let guide = safeAreaLayoutGuide
        let width = guide.layoutFrame.size.width
        widthMaxConstraint?.constant = width - 100
    }
    
    func setSubtitle(_ sub: String?) {
        if let s = sub {
            subtitleLabel.text = " \(s) "
        }
        else {
            subtitleLabel.text = nil
        }
    }
    
    func setSubtitleTextColor(_ color: UIColor) {
        subtitleLabel.textColor = color
    }
    
    func setSubtitleTextSize(_ size: CGFloat) {
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: size)
    }
    
    func setPaddingSubtitle(_ padding: CGFloat) {
        bottomConstraint?.constant = -padding
    }
}
