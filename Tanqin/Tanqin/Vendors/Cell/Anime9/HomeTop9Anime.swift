import UIKit
import SDWebImage
import SnapKit

class HomeTop9Anime: BaseCollectionCell {
    
    // MARK: - properties
    fileprivate let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_thumb"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let lbIndex: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(of: 28)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.layer.cornerRadius = 4
        view.textAlignment = .center
        view.layer.borderColor = UIColor(rgb: 0x666666).cgColor
        view.layer.borderWidth = 1
        view.textColor = UIColor(rgb: 0x666666)
        return view
    }()
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(of: 14)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = UIColor.white
        return view
    }()
    
    fileprivate let imageEye: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_eye"))
        return view
    }()
    
    fileprivate let lbView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 12)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.clipsToBounds = true
        view.text = ""
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
        contentView.backgroundColor = UIColor(rgb: 0x0F1017)
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        contentView.addSubview(lbIndex)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageEye)
        contentView.addSubview(lbView)
        
        lbIndex.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(self.lbIndex.snp.trailing).offset(12)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
            make.width.equalTo(self.imageView.snp.height).multipliedBy(0.75)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(self.imageView.snp.trailing).offset(16)
        }
        
        imageEye.snp.makeConstraints { make in
            make.leading.equalTo(self.imageView.snp.trailing).offset(16)
            make.height.equalTo(8)
            make.width.equalTo(12)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
        }
        
        lbView.snp.makeConstraints { make in
            make.leading.equalTo(self.imageEye.snp.trailing).offset(4)
            make.height.equalTo(16)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
        }
    }
    
    // MARK: - public
    var aniModel: AniModel! {
        didSet {
            titleLabel.text = aniModel.enName
            lbView.text = aniModel.view
            imageView.sd_setImage(with: aniModel.posterURL, placeholderImage: UIImage(named: "ic_thumb"))
        }
    }
    
    var index: Int = 0 {
        didSet {
            lbIndex.text = "\(index + 1)"
        }
    }
}
