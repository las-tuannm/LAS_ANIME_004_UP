import UIKit

class HomeTrendingCell: BaseCollectionCell {
    // MARK: - override from supper view
    override class func size(width: CGFloat = 0) -> CGSize {
        if UIDevice.isIPad {
            return .init(width: width, height: 48 + width/5)
        } else {
            return .init(width: width, height: 48 + (width - 40)*2/5)
        }
        
    }

    fileprivate let listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.registerItem(cell: HomeItemTrendingCell.self)
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
        contentView.addSubview(listCollectionView)

        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().offset(0)
        }
        
        setupAnimateLoadingView()
    }
    
    // MARK: - public
    var data: [AniModel] = [] {
        didSet {
            if data.count > 0 {
                loadingView.stopAnimating()
                loadingView.isHidden = true
                
                listCollectionView.reloadData()
            }
        }
    }
    
    var onSelected: ((AniModel) -> Void)?
}

extension HomeTrendingCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(data.count, kMaxItemDisplay)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeItemTrendingCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.aniModel = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelected?(data[indexPath.row])
    }
}

extension HomeTrendingCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HomeItemTrendingCell.size(height: collectionView.size.height)
    }
}
