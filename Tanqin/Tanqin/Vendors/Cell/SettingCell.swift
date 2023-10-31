import UIKit

class SettingCell: BaseCollectionCell {
    
    // MARK: - properties
    fileprivate let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_not_select"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 18)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        return view
    }()
    
    fileprivate let sourceLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 18)
        view.numberOfLines = 2
        view.text = "Aniwave"
        view.lineBreakMode = .byWordWrapping
        view.textColor = UIColor.init(rgb: 0x932EFF)
        return view
    }()
    
    fileprivate let imageViewSource: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_source_next"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
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
    
    // MARK: - private
    private func drawUIs() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(imageViewSource)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.imageView.snp.trailing).offset(16)
            make.top.bottom.equalToSuperview()
        }
        
        imageViewSource.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(18)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.imageViewSource.snp.leading).offset(-16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - public
    var typeLayout: SettingLayout! {
        didSet {
            titleLabel.text = typeLayout.getTitle()
            imageView.image = typeLayout.getImage()
            if typeLayout == .source {
                sourceLabel.isHidden = false
                imageViewSource.isHidden = false
                sourceLabel.text = HTMLService.shared.getSourceAnime().getTitleSource()
            } else {
                sourceLabel.isHidden = true
                imageViewSource.isHidden = true
            }
        }
    }
}
