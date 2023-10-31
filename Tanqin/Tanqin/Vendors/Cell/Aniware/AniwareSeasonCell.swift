import UIKit
import SDWebImage
import SnapKit

class AniwareSeasonCell: BaseCollectionCell {
    // MARK: - override from supper view
    override class func size(height: CGFloat = 0) -> CGSize {
        return .init(width: 150, height: 100)
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
    
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 24)
        view.numberOfLines = 2
        view.layer.cornerRadius = 8
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
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
        contentView.layer.cornerRadius = 8
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
    }
    
    // MARK: - public
    var aniSeasonModel: AniSeasonModel! {
        didSet {
            titleLabel.text = aniSeasonModel.name
            imageView.sd_setImage(with: aniSeasonModel.posterURL, placeholderImage: UIImage(named: "ic_thumb"))
        }
    }
    
    var linkSelect: String = "" {
        didSet {
            if !linkSelect.isEmpty && linkSelect.contains(aniSeasonModel.detailLink) {
                self.contentView.layer.borderWidth = 2
                self.contentView.layer.borderColor =  UIColor.init(rgb: 0x932EFF).cgColor
            } else {
                self.contentView.layer.borderWidth = 0
                self.contentView.layer.borderColor =  UIColor.clear.cgColor
            }
        }
    }
    
}
