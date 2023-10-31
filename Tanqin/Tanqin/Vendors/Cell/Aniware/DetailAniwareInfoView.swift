import UIKit
import SnapKit

class DetailAniwareInfoView: UIView {

    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 14)
        view.lineBreakMode = .byWordWrapping
        view.textColor = .init(rgb: 0x757575)
        return view
    }()
    
    fileprivate let detailLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 14)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
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
    
    private func drawUIs() {
        backgroundColor = .clear
        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(22)
            make.leading.equalToSuperview().offset(0)
            make.width.greaterThanOrEqualTo(20)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(8)
            make.height.greaterThanOrEqualTo(22)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(4)
        }
    }
    
    func setText(title: String, detail: String){
        titleLabel.text = title
        detailLabel.text = detail
        titleLabel.layoutIfNeeded()
        detailLabel.layoutIfNeeded()
    }
    
}
