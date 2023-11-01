import UIKit
import AppLovinSDK

class AppLovinNativeAdTableCell: UITableViewCell {
    
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
    
}
