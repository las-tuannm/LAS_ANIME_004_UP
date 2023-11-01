import UIKit
import SDWebImage
import SnapKit

class HomeTopAniware: BaseCollectionCell {
    
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
        view.font = UIFont.medium(of: 32)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        view.layer.cornerRadius = 4
        view.textAlignment = .center
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
    
    fileprivate let typeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(of: 14)
        view.textColor = .white.withAlphaComponent(0.6)
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
        contentView.addSubview(stackDetail)
        
        viewView.addSubview(viewLabel)
        viewView.addSubview(viewImage)
        viewDub.addSubview(dubLabel)
        viewDub.addSubview(dubImage)
        viewRate.addSubview(rateLabel)
        
        lbIndex.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(4)
            make.top.equalToSuperview().offset(0)
            make.width.equalTo(50)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(self.lbIndex.snp.trailing).offset(5)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
            make.width.equalTo(self.imageView.snp.height).multipliedBy(0.75)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(self.imageView.snp.trailing).offset(16)
        }
        
        stackDetail.snp.makeConstraints { make in
            make.leading.equalTo(self.imageView.snp.trailing).offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.height.equalTo(18)
        }
        
        viewImage.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(14)
            make.leading.equalToSuperview().offset(4)
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
        stackDetail.addArrangedSubview(typeLabel)
        
        typeLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(30)
        }
        
        
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
    
    var index: Int = 0 {
        didSet {
    
            var colorIndex = UIColor.white
            if index == 0 {
                colorIndex = UIColor.init(rgb: 0x932EFF)
            } else if index == 1 {
                colorIndex = UIColor.red
            } else if index == 2 {
                colorIndex = UIColor.yellow
            }
            
            let strokeTextAttributes = [
              NSAttributedString.Key.strokeColor : colorIndex,
              NSAttributedString.Key.foregroundColor : UIColor.clear,
              NSAttributedString.Key.strokeWidth : -4.0,
              NSAttributedString.Key.font : UIFont.medium(of: 42)!]
              as [NSAttributedString.Key : Any]

            lbIndex.attributedText = NSMutableAttributedString(string: "\(index + 1)", attributes: strokeTextAttributes)
        }
    }
}
