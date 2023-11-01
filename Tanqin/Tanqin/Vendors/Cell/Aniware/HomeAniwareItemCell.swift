import UIKit
import SDWebImage
import SnapKit

class HomeAniwareItemCell: BaseCollectionCell {
    // MARK: - override from supper view
    override class func size(height: CGFloat = 0) -> CGSize {
        return .init(width: 125, height: 212)
    }
    
    // MARK: - properties
    
    fileprivate let viewInfo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb: 0x242424)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    fileprivate let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_thumb"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(of: 14)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        return view
    }()
    
    fileprivate let viewView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb: 0x552a92)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    fileprivate let viewLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 12)
        view.textColor = .white
        view.textAlignment = .center
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let viewImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_cc"))
        return view
    }()
    
    fileprivate let viewDub: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb: 0x8f7003)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    fileprivate let dubLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 12)
        view.textColor = .white
        view.textAlignment = .center
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let dubImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_voice"))
        return view
    }()
    
    fileprivate let viewRate: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb: 0x666666)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    fileprivate let rateLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 12)
        view.textColor = .white
        view.textAlignment = .center
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let stackDetail: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        return view
    }()
    
    fileprivate let typeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 10)
        view.textColor = .black
        view.textAlignment = .center
        view.backgroundColor = UIColor.white
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
        typeLabel.roundCorners(corners: [.topLeft, .bottomRight], radius: 8)
        super.layoutSubviews()
    }
    
    // MARK: - private
    private func drawUIs() {
        contentView.backgroundColor = .clear
        contentView.addSubview(viewInfo)
        contentView.addSubview(typeLabel)
        viewInfo.addSubview(imageView)
        contentView.addSubview(titleLabel)
        viewInfo.addSubview(stackDetail)
        
        viewView.addSubview(viewLabel)
        viewView.addSubview(viewImage)
        viewDub.addSubview(dubLabel)
        viewDub.addSubview(dubImage)
        viewRate.addSubview(rateLabel)
        
        typeLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(18)
            make.width.greaterThanOrEqualTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        viewInfo.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(0)
        }
        
        stackDetail.snp.makeConstraints { make in
            make.leading.equalTo(4)
            make.bottom.equalTo(-4)
            make.height.equalTo(18)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(stackDetail.snp.top).offset(-4)
        }
        
        viewImage.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(14)
            make.leading.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
        }
        
        viewLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.viewImage.snp.trailing).offset(2)
            make.trailing.equalToSuperview().offset(-4)
            make.top.bottom.equalToSuperview().offset(0)
        }
        
        dubImage.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(8)
            make.leading.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
        }
        
        dubLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.dubImage.snp.trailing).offset(2)
            make.trailing.equalToSuperview().offset(-4)
            make.top.bottom.equalToSuperview().offset(0)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.top.bottom.equalToSuperview().offset(0)
        }
        
        stackDetail.addArrangedSubview(viewView)
        stackDetail.addArrangedSubview(viewDub)
        stackDetail.addArrangedSubview(viewRate)
        
    }
    
    // MARK: - public
    var aniModel: AniModel! {
        didSet {
            titleLabel.text = aniModel.enName
            imageView.sd_setImage(with: aniModel.posterURL, placeholderImage: UIImage(named: "ic_thumb"))
            if aniModel.sub == "" {
                viewView.isHidden = true
            } else {
                viewView.isHidden = false
                viewLabel.text = aniModel.sub
            }
            
            if aniModel.eps == "" {
                viewRate.isHidden = true
            } else {
                viewRate.isHidden = false
                rateLabel.text = aniModel.eps
            }
            
            if aniModel.dub == "" {
                viewDub.isHidden = true
            } else {
                viewDub.isHidden = false
                dubLabel.text = aniModel.dub
            }
            
            if aniModel.type == "" {
                typeLabel.isHidden = true
            } else {
                typeLabel.isHidden = false
                typeLabel.text = " \(aniModel.type ?? "") "
                typeLabel.layoutIfNeeded()
            }
        }
    }
}
