import UIKit
import SDWebImage
import SnapKit

class DetailAniwareMoreInfoCell: BaseCollectionCell {

    fileprivate let viewInfo = UIView()
    fileprivate let tyleLabel = DetailInfoView()
    fileprivate let studioLabel = DetailInfoView()
    fileprivate let dateAriLabel = DetailInfoView()
    fileprivate let statusLabel = DetailInfoView()
    fileprivate let genreLabel = DetailInfoView()
    fileprivate let premieredLabel = DetailInfoView()
    
    fileprivate let readMoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 14)
        view.textColor = .init(rgb: 0xBB52FF)
        view.text = "LESS"
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var data: AniDetailModel? {
        didSet {
            loadingView.stopAnimating()
            loadingView.isHidden = true
            self.setValueForView()
        }
    }
    
    var numberLineDes: Int = 0 {
        didSet {
            if numberLineDes == 0 {
                viewInfo.isHidden = false
                readMoreLabel.isHidden = false
            } else {
                viewInfo.isHidden = true
                readMoreLabel.isHidden = true
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
        contentView.addSubview(readMoreLabel)
        contentView.addSubview(viewInfo)
        
        readMoreLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectReamore)))
        
        viewInfo.addSubview(tyleLabel)
        viewInfo.addSubview(studioLabel)
        viewInfo.addSubview(dateAriLabel)
        viewInfo.addSubview(statusLabel)
        viewInfo.addSubview(genreLabel)
        viewInfo.addSubview(premieredLabel)
        
        readMoreLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.height.equalTo(32)
            make.bottom.equalToSuperview().offset(0)
            make.width.greaterThanOrEqualTo(60)
        }
        
        viewInfo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalTo(self.readMoreLabel.snp.top).offset(0)
            make.leading.equalToSuperview().offset(0)
        }
        
        tyleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(22)
        }
        
        studioLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.tyleLabel.snp.bottom).offset(0)
            make.height.equalTo(22)
        }
        
        dateAriLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.studioLabel.snp.bottom).offset(0)
            make.height.equalTo(22)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.dateAriLabel.snp.bottom).offset(0)
            make.height.equalTo(22)
        }
        
        premieredLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.statusLabel.snp.bottom).offset(0)
            make.height.equalTo(22)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.premieredLabel.snp.bottom).offset(0)
            make.height.equalTo(44)
        }
        
        setupAnimateLoadingView()
    }
    
    @objc func selectReamore(){
        onSelectedReadmore?()
    }
    
    func setValueForView() {
        tyleLabel.setText(title: "Type:", detail: data?.type ?? "")
        studioLabel.setText(title: "Studios:", detail: data?.studios ?? "")
        dateAriLabel.setText(title: "Date aired:", detail: data?.dateAired ?? "")
        statusLabel.setText(title: "Status:", detail: data?.status ?? "")
        genreLabel.setText(title: "Genre:", detail: (data?.genres ?? []).map{ $0.name }.joined(separator: ", "))
        premieredLabel.setText(title: "Premiered:", detail: data?.premiered ?? "")
    }
    
}
