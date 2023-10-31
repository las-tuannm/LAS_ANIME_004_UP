import UIKit
import SnapKit

class DetailDescribeCell: BaseCollectionCell {
    
    fileprivate let introLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 14)
        view.textColor = .white
        view.adjustsFontSizeToFitWidth = false
        view.lineBreakMode = .byTruncatingTail
        view.numberOfLines = 0
        return view
    }()
    
    fileprivate let readMoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 14)
        view.textColor = .init(rgb: 0xBB52FF)
        view.text = "READ MORE"
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var data: AniDetailModel? {
        didSet {
            loadingView.stopAnimating()
            loadingView.isHidden = true
            setValueForView()
        }
    }
    
    var numberLineDes: Int = 0 {
        didSet {
            self.introLabel.numberOfLines = numberLineDes
            self.introLabel.layoutIfNeeded()
            self.layoutIfNeeded()
            if numberLineDes == 0 {
                readMoreLabel.isHidden = true
                readMoreLabel.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            } else {
                readMoreLabel.isHidden = false
                readMoreLabel.snp.updateConstraints { make in
                    make.height.equalTo(32)
                }
            }
        }
    }
    
    var onSelectedReadmore: (() -> Void)?
    
    // MARK: - initital
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.drawUIs()
    }
    
    private func drawUIs() {
        
        contentView.backgroundColor = .clear
        contentView.addSubview(introLabel)
        contentView.addSubview(readMoreLabel)
        
        readMoreLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectReamore)))

        readMoreLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.height.equalTo(32)
            make.bottom.equalToSuperview().offset(0)
            make.width.greaterThanOrEqualTo(60)
        }
        
        introLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalTo(self.readMoreLabel.snp.top).offset(0)
        }
        
        setupAnimateLoadingView()
    }
    
    @objc func selectReamore(){
        onSelectedReadmore?()
    }
    
    func setValueForView(){
        introLabel.text = data?.description ?? ""
    }
    
}
