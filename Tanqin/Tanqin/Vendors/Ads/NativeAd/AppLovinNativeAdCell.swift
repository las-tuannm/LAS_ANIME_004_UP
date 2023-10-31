import UIKit
import AppLovinSDK

class AppLovinNativeAdCell: UICollectionViewCell {
    
    // MARK: - properties
    lazy var nativeView: AppLovinNativeAdView = {
        let view = AppLovinNativeAdView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var nativeAd: Any? = nil {
        didSet { nativeView.nativeAdView = nativeAd as? MANativeAdView }
    }
    
    // MARK: - initial
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialViews()
    }
    
    // MARK: - private
    private func initialViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        nativeView.backgroundColor = .clear
        contentView.addSubview(nativeView)
        
        // auto layout
        nativeView.leftAnchor.constraint(equalTo: leftAnchor, constant: NativeAdStyle.paddingHorizontal).isActive = true
        nativeView.rightAnchor.constraint(equalTo: rightAnchor, constant: -NativeAdStyle.paddingHorizontal).isActive = true
        nativeView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        nativeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: - helper
    static var height: CGFloat {
        return AppLovinNativeAdView.height
    }
    
    class func size(_ width: CGFloat = 0) -> CGSize {
        if width == 0 {
            return CGSize(width: UIScreen.main.bounds.size.width, height: AppLovinNativeAdView.height)
        }
        return CGSize(width: width, height: AppLovinNativeAdView.height)
    }
}
