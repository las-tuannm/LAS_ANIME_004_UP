import UIKit
import SDWebImage
import SnapKit

class DetailInfoCell: BaseCollectionCell {
    
    override class func size(width: CGFloat = 0) -> CGSize {
        return .init(width: width, height: 372)
    }
    
    // MARK: - properties
    fileprivate let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_thumb"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 20)
        view.textColor = .white
        view.text = ""
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate let starView: StarView = {
        let starView = StarView()
        starView.starCount = 5
        starView.isUserInteractionEnabled = false
        starView.fillColor = .init(rgb: 0xFFBC2E)
        starView.strokeColor = .init(rgb: 0xFFBC2E)
        return starView
    }()
    
    fileprivate let watchNowLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.font = UIFont.bold(of: 12)
        view.layer.cornerRadius = 16
        view.textAlignment = .center
        view.text = "Watch now"
        view.textColor = .white
        view.backgroundColor = .init(UIColor(rgb: 0x7938C3))
        view.clipsToBounds = true
        return view
    }()
    
    var data: AniDetailModel? {
        didSet {
            loadingView.stopAnimating()
            loadingView.isHidden = true
            self.setValueForView()
        }
    }
    
    var onSelectedWatchNow: (() -> Void)?
    var onSelectedContinueWatch: (() -> Void)?
    
    // MARK: - initital
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.drawUIs()
    }
    
    private func drawUIs() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(starView)
        contentView.addSubview(watchNowLabel)
        watchNowLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(watchNowClick)))
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview().offset(0)
            make.width.equalTo(169)
            make.height.equalTo(225)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(0)
            make.centerX.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(59)
        }
        
        starView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(120)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(0)
        }
        
        watchNowLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(150)
            make.top.equalTo(self.starView.snp.bottom).offset(16)
        }
        
        setupAnimateLoadingView()
    }
    
    @objc func watchNowClick() {
        let recentAni = RecentAni.getRecentAni(id: data?.id ?? "")
        if recentAni != nil {
            onSelectedContinueWatch?()
        } else {
            onSelectedWatchNow?()
        }
    }
    
    func setValueForView() {
        imageView.sd_setImage(with: data?.posterURL, placeholderImage: UIImage(named: "ic_thumb"))
        nameLabel.text = data?.enName
        let recentAni = RecentAni.getRecentAni(id: data?.id ?? "")
        if recentAni != nil {
            watchNowLabel.text = "Continue Watch E\(recentAni!.episode)"
        }
        if data?.scores == nil || data?.scores == "" {
            starView.rating = 0.0
        } else {
            starView.rating = CGFloat(Float(data!.scores) ?? 0.0)/2
        }
    }
}
