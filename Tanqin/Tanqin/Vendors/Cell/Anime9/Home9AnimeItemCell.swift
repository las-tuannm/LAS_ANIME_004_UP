import UIKit
import SDWebImage
import SnapKit

class Home9AnimeItemCell: BaseCollectionCell {
    // MARK: - override from supper view
    override class func size(height: CGFloat = 0) -> CGSize {
        return .init(width: 125, height: 212)
    }
    
    // MARK: - properties
    fileprivate let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_thumb"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 14)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        return view
    }()
    
    fileprivate let qualityLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 10)
        view.textColor = .black
        view.textAlignment = .center
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let epView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb: 0xBB52FF)
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let epLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 8)
        view.textColor = .white
        view.textAlignment = .center
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let subLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 8)
        view.textColor = .white
        view.textAlignment = .center
        view.backgroundColor = UIColor.init(rgb: 0xc39d00)
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
        
        qualityLabel.roundCorners(corners: [.topLeft, .bottomRight], radius: 8)
        epView.roundCorners(corners: [.bottomLeft, .topRight], radius: 8)
        subLabel.roundCorners(corners: [.topLeft, .bottomRight], radius: 8)
    }
    
    // MARK: - private
    private func drawUIs() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(qualityLabel)
        contentView.addSubview(epView)
        epView.addSubview(epLabel)
        contentView.addSubview(subLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(47)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(0)
        }
        
        qualityLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(32)
            make.height.equalTo(18)
        }
        
        epView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom).offset(0)
            make.width.greaterThanOrEqualTo(32)
            make.height.equalTo(18)
        }
        
        epLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.top.equalToSuperview().offset(0)
        }
        
        subLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom).offset(0)
            make.width.equalTo(32)
            make.height.equalTo(18)
        }
        
    }
    
    // MARK: - public
    var aniModel: AniModel! {
        didSet {
            titleLabel.text = aniModel.enName
            imageView.sd_setImage(with: aniModel.posterURL, placeholderImage: UIImage(named: "ic_thumb"))
            if aniModel.quality == "" {
                qualityLabel.isHidden = true
            } else {
                qualityLabel.isHidden = false
                qualityLabel.text = aniModel.quality
            }
            
            if aniModel.sub == "" {
                subLabel.isHidden = true
            } else {
                subLabel.isHidden = false
                subLabel.text = aniModel.sub
            }
            
            if aniModel.eps == "" {
                epView.isHidden = true
            } else {
                epView.isHidden = false
                epLabel.text = aniModel.eps
                self.epView.layoutIfNeeded()
            }
        }
    }
}
