import UIKit
import SDWebImage
import SnapKit

class HomeItemTrendingCell: BaseCollectionCell {
    // MARK: - override from supper view
    override class func size(height: CGFloat = 0) -> CGSize {
        return .init(width: (height-48)*5/2, height: height)
    }
    
    // MARK: - properties
    fileprivate let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_thumb"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let viewName: GradientView = {
        let view = GradientView()
        view.startColor = UIColor.black.withAlphaComponent(0)
        view.endColor = UIColor.black
        return view
    }()
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 16)
        view.numberOfLines = 5
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        return view
    }()
    
    fileprivate let watchNowLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 12)
        view.layer.cornerRadius = 16
        view.textAlignment = .center
        view.text = "Watch now"
        view.textColor = .white
        view.backgroundColor = .init(UIColor(rgb: 0x7938C3))
        view.clipsToBounds = true
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - private
    private func drawUIs() {
        contentView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(viewName)
        viewName.addSubview(titleLabel)
        viewName.addSubview(watchNowLabel)
        
        viewName.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        watchNowLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(100)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.watchNowLabel.snp.top).offset(-16)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
    // MARK: - public
    var aniModel: AniModel! {
        didSet {
            titleLabel.text = aniModel.enName
            imageView.sd_setImage(with: aniModel.posterURL, placeholderImage: UIImage(named: "ic_thumb"))
        }
    }
}
