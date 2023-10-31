import UIKit
import SnapKit

class PopularNewestCell: BaseCollectionCell {
    // MARK: - override from supper view
    override class func size(width: CGFloat = 0) -> CGSize {
        return .init(width: width, height: 257)
    }
    
    // MARK: - properties
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 18)
        view.textColor = .white
        view.text = "Newest"
        return view
    }()
    
    fileprivate let seeMoreButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("See All", for: .normal)
        view.setTitleColor(.init(rgb: 0xBB52FF), for: .normal)
        view.titleLabel?.font = UIFont.medium(of: 14)
        view.isHidden = true
        return view
    }()
    
    fileprivate let reloadButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Reload data", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.medium(of: 14)
        view.backgroundColor = .init(UIColor(rgb: 0x7938C3))
        view.layer.cornerRadius = 16
        view.isHidden = true
        return view
    }()
    
    fileprivate let listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.registerItem(cell: Home9AnimeItemCell.self)
        view.registerItem(cell: HomeAniwareItemCell.self)
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(seeMoreButton)
        contentView.addSubview(listCollectionView)
        contentView.addSubview(reloadButton)
        
        seeMoreButton.addTarget(self, action: #selector(moreClick), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(reloadClick), for: .touchUpInside)
        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        
        seeMoreButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().offset(0)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.center.equalTo(self.listCollectionView.snp.center)
            make.height.equalTo(32)
            make.width.equalTo(100)
        }
        
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(seeMoreButton.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().offset(0)
        }
        
        setupAnimateLoadingView()
    }
    
    // MARK: - public
    var data: [AniModel] = [] {
        didSet {
            if data.count == 0 {
                loadingView.stopAnimating()
                loadingView.isHidden = true
                seeMoreButton.isHidden = true
                reloadButton.isHidden = false
            } else {
                if data[0].id != "" {
                    loadingView.stopAnimating()
                    loadingView.isHidden = true
                    seeMoreButton.isHidden = false
                    reloadButton.isHidden = true
                    listCollectionView.reloadData()
                }
            }
            
        }
    }
    
    var onSelected: ((AniModel) -> Void)?
    var onMore: (() -> Void)?
    var onReload: (() -> Void)?
    
    // MARK: - event
    @objc func moreClick() {
        onMore?()
    }
    
    @objc func reloadClick() {
        onReload?()
    }
}

extension PopularNewestCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.count > 0 && data[0].id != "" {
            return min(data.count, kMaxItemDisplay)
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if HTMLService.shared.getSourceAnime() == .anime9 {
            let cell: Home9AnimeItemCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.aniModel = data[indexPath.row]
            return cell
        } else {
            let cell: HomeAniwareItemCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.aniModel = data[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelected?(data[indexPath.row])
    }
}

extension PopularNewestCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if HTMLService.shared.getSourceAnime() == .anime9 {
            return Home9AnimeItemCell.size(height: collectionView.size.height)
        } else {
            return HomeAniwareItemCell.size(height: collectionView.size.height)
        }
    }
}
