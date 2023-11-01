import UIKit

class SearchTypeItem: BaseCollectionCell {
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 14)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    fileprivate let gradientView: GradientView = {
        let view = GradientView()
        view.isHidden = true
        view.horizontalMode = true
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
        contentView.backgroundColor = .init(rgb: 0xA74BFA).withAlphaComponent(0.11)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        
        gradientView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - public
    var aniGenreModel: AniGenreModel! {
        didSet {
            if let hexStart = aniGenreModel.startColor, let hexEnd = aniGenreModel.endColor {
                gradientView.isHidden = false
                gradientView.startColor = UIColor.init(rgb: hexStart)
                gradientView.endColor = UIColor.init(rgb: hexEnd)
            } else {
                gradientView.isHidden = true
            }
            titleLabel.text = aniGenreModel.name
        }
    }
}
