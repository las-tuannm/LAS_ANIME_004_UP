import UIKit

class DetailSuggestCell: BaseCollectionCell {
    
    override class func size(width: CGFloat = 0) -> CGSize {
        return .init(width: width, height: 257)
    }
    
    // MARK: - properties
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 18)
        view.textColor = .white
        view.text = "More like this"
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
        contentView.addSubview(listCollectionView)
        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().offset(0)
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

extension DetailSuggestCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
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

extension DetailSuggestCell: UICollectionViewDelegateFlowLayout {
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
