import UIKit
import SnapKit

class ChooseSeasonCell: UICollectionViewCell {
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 14)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        view.backgroundColor = .init(rgb: 0xA74BFA).withAlphaComponent(0.11)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.textAlignment = .center
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
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(6)
            make.trailing.bottom.equalToSuperview().offset(-6)
        }
    }
    
    // MARK: - public
    var aniEpisodesModel: AniEpisodesModel! {
        didSet {
            titleLabel.text = "\(aniEpisodesModel.episode)"
        }
    }
    
    public var episodeId: String = "" {
        didSet {
            if episodeId == aniEpisodesModel.sourceID {
                titleLabel.backgroundColor = .init(rgb: 0xA74BFA)
            } else {
                titleLabel.backgroundColor = .init(rgb: 0xA74BFA).withAlphaComponent(0.11)
            }
        }
    }
}
