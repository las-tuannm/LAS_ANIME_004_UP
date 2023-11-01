import UIKit
import GoogleMobileAds

class AdmobNativeAdCell: UICollectionViewCell {
    
    // MARK: - properties
    private var nativeView: AdmobNativeAdView!
    
    var nativeAd: Any? = nil {
        didSet { nativeView.nativeAd = nativeAd as? GADNativeAd }
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
        guard let nibObjects = Bundle.current.loadNibNamed("AdmobNativeAdView", owner: nil, options: nil),
              let adView = nibObjects.first as? AdmobNativeAdView else {
            return
        }
        
        backgroundColor = .clear
        self.backgroundColor = .clear
        nativeView = adView
        nativeView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nativeView)
        
        // auto layout
        nativeView.leftAnchor.constraint(equalTo: leftAnchor, constant: NativeAdStyle.paddingHorizontal).isActive = true
        nativeView.rightAnchor.constraint(equalTo: rightAnchor, constant: -NativeAdStyle.paddingHorizontal).isActive = true
        nativeView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        nativeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: - helper
    static var height: CGFloat {
        return AdmobNativeAdView.height
    }
    
    class func size(_ width: CGFloat = 0) -> CGSize {
        if width == 0 {
            return CGSize(width: UIScreen.main.bounds.size.width, height: AdmobNativeAdView.height)
        }
        return CGSize(width: width, height: AdmobNativeAdView.height)
    }
}
