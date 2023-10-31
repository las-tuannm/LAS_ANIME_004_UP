import UIKit
import SnapKit

class ChooseServerCell: UICollectionViewCell {
    
    fileprivate let iconImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ic_cc")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 14)
        view.numberOfLines = 1
        view.textColor = .white
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate let infoLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.italic(of: 12)
        view.numberOfLines = 1
        view.textAlignment = .left
        view.textColor = .white.withAlphaComponent(0.5)
        view.backgroundColor = .clear
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
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        
        iconImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(self.infoLabel.snp.top)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(15)
        }
    }
    
    // MARK: - public
    var fileSv: FileSVModel? {
        didSet {
            guard let f = fileSv else { return }
            
            switch f.type {
            case .sub:
                iconImage.image = UIImage(named: "ic_cc")
            case .softsub:
                iconImage.image = UIImage(named: "ic_cc")
            case .dub:
                iconImage.image = UIImage(named: "ic_voice")
            }
            
            titleLabel.text = f.title
            infoLabel.text = f.name
        }
    }
    
    var fileSvSelected: FileSVModel? {
        didSet {
            if fileSv?.file == fileSvSelected?.file {
                contentView.backgroundColor = .init(rgb: 0xA74BFA)
            } else {
                contentView.backgroundColor = .init(rgb: 0xA74BFA).withAlphaComponent(0.11)
            }
        }
    }
    
}
