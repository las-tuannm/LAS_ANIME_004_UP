import UIKit

class DetailAniwareSeasonCell: BaseCollectionCell {
    
    override class func size(width: CGFloat = 0) -> CGSize {
        return .init(width: width, height: 140)
    }
    
    // MARK: - properties
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 18)
        view.textColor = .white
        view.text = "Season"
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
        view.registerItem(cell: AniwareSeasonCell.self)
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
    var data: [AniSeasonModel] = [] {
        didSet {
            loadingView.stopAnimating()
            loadingView.isHidden = true
            listCollectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.reloadToSeasonActive()
            })
        }
    }
    
    var linkSelect: String = "" {
        didSet {
            listCollectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.reloadToSeasonActive()
            })
        }
    }
    
    var onSelected: ((AniSeasonModel) -> Void)?
    
    func reloadToSeasonActive() {
        if let i = data.firstIndex(where: { !linkSelect.isEmpty && linkSelect.contains($0.detailLink) }) {
            let index = IndexPath(row: i, section: 0)
            listCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        }
    }
}

extension DetailAniwareSeasonCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AniwareSeasonCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.aniSeasonModel = data[indexPath.row]
        cell.linkSelect = self.linkSelect
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelected?(data[indexPath.row])
    }
}

extension DetailAniwareSeasonCell: UICollectionViewDelegateFlowLayout {
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
        return AniwareSeasonCell.size(height: collectionView.size.height)
    }
}
