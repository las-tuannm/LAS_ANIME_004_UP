import UIKit
import SnapKit

class SettingFontCell: BaseCollectionCell {
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 18)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        return view
    }()
    
    fileprivate let valueLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 18)
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        return view
    }()
    
    fileprivate let slider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.maximumTrackTintColor = UIColor(rgb: 0xB3B3B3)
        view.minimumTrackTintColor = UIColor(rgb: 0x932EFF)
        
        let image = UIImage.getImage("slider-thumb")?.sd_tintedImage(with: UIColor.init(rgb: 0xBB52FF))
        view.setThumbImage(image, for: .normal)

        return view
    }()
    
    // MARK: - initital
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.drawUIs()
    }
    
    // MARK: - private
    private func drawUIs() {
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(slider)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(20)
        }
        slider.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(8)
        }
        
        slider.addTarget(self, action: #selector(valueSliderChange), for: .valueChanged)
        
    }
    
    @objc func valueSliderChange(){
        valueLabel.text = "\(Int(slider.value))"
        if typeLayout == .text_size {
            UserDefaults.standard.set(Int(slider.value), forKey: "subtitle_size")
        } else {
            UserDefaults.standard.set(Int(slider.value), forKey: "subtitle_position")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - public
    var typeLayout: SettingLayout! {
        didSet {
            titleLabel.text = typeLayout.getTitle()
            if typeLayout == .text_size {
                slider.minimumValue = 15
                slider.maximumValue = 30
                slider.value = Float(AppInfo.getSubTitleSize())
                valueLabel.text = "\(AppInfo.getSubTitleSize())"
            } else {
                slider.minimumValue = 0
                slider.maximumValue = 100
                slider.value = Float(AppInfo.getSubTitlePosition())
                valueLabel.text = "\(AppInfo.getSubTitlePosition())"
            }
        }
    }
    
    class func createThumbSider() -> UIImage? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.backgroundColor = UIColor(rgb: 0x932EFF)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view.image()
    }
    
}
