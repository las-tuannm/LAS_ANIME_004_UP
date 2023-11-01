import UIKit
import SDWebImage
import SnapKit

class AniwareSuggestCell: BaseCollectionCell {
    // MARK: - override from supper view
    override class func size(height: CGFloat = 0) -> CGSize {
        return .init(width: 125, height: 186)
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
        view.layer.cornerRadius = 8
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
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
    }
    
    // MARK: - public
    var aniModel: AniModel! {
        didSet {
            titleLabel.text = aniModel.enName
            imageView.sd_setImage(with: aniModel.posterURL, placeholderImage: UIImage(named: "ic_thumb"))
            
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
