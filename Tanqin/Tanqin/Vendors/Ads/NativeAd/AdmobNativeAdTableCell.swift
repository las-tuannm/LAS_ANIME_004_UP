import UIKit
import GoogleMobileAds

class AdmobNativeAdTableCell: UITableViewCell {
    
    // MARK: - properties
    private var nativeView: AdmobNativeAdView!
    
    var nativeAd: Any? = nil {
        didSet { nativeView.nativeAd = nativeAd as? GADNativeAd }
    }
    
    // MARK: - initial
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        selectionStyle = .none
        
        backgroundColor = UIColor.init(rgb: 0xF5F7F9)
        contentView.backgroundColor = UIColor.init(rgb: 0xF5F7F9)
        nativeView = adView
        nativeView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nativeView)
        
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
    
}
