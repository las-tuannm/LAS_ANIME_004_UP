import UIKit
import SnapKit

class DetailAniwareEpisodesCell: BaseCollectionCell {
    
    fileprivate let imgSort: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "ic_arrow_asc"), for: .normal)
        return view
    }()
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 18)
        view.textColor = .white
        view.text = "Episodes"
        return view
    }()

    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.registerItem(cell: DetailAniwareEpisodesPathCell.self)
        return view
    }()
    
    var aniEpisodes: [AniEpisodesModel] = [] {
        didSet {
            loadingView.stopAnimating()
            loadingView.isHidden = true
            if self.typeSort == 0 {
                self.aniEpisodesView = self.aniEpisodes
            } else {
                self.aniEpisodesView = self.aniEpisodes.reversed()
            }
            self.setValueForView()
        }
    }
    
    var aniEpisodesView: [AniEpisodesModel] = []
    
    var typeSort: Int = 0 {
        didSet {
            if typeSort == 0 {
                imgSort.setImage(UIImage(named: "ic_arrow_asc"), for: .normal)
            } else {
                imgSort.setImage(UIImage(named: "ic_arrow_des"), for: .normal)
            }
        }
    }
    
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(imgSort)
        contentView.addSubview(collectionView)
        
        imgSort.addTarget(self, action: #selector(sortClick), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        
        imgSort.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel.snp.centerY)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(8)
            make.height.width.equalTo(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
        }
        
        setupAnimateLoadingView()
    }
    
    @objc func sortClick() {
        changeSort?()
    }
    
    var changeSort: (() -> Void)?
    
    func setValueForView(){
        self.collectionView.reloadData()
    }
    var onSelected: ((AniEpisodesModel) -> Void)?
}

extension DetailAniwareEpisodesCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if aniEpisodesView.count % (numberEpisodes*10) == 0 {
            return aniEpisodesView.count/(numberEpisodes*10)
        } else {
            return aniEpisodesView.count/(numberEpisodes*10) + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DetailAniwareEpisodesPathCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        var listEpisodes: [AniEpisodesModel] = []
        for i in indexPath.row*(numberEpisodes*10)..<(indexPath.row + 1)*(numberEpisodes*10) {
            if i < aniEpisodesView.count{
                listEpisodes.append(aniEpisodesView[i])
            }
        }
        cell.aniEpisodes = listEpisodes
        cell.onSelected = { aniEpisode in
            self.onSelected?(aniEpisode)
        }
        return cell
    }
}

extension DetailAniwareEpisodesCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        var height = 0
        if self.aniEpisodesView.count < numberEpisodes*numberRowEpisodes {
            if self.aniEpisodesView.count % numberEpisodes == 0 {
                height = self.aniEpisodesView.count/numberEpisodes*heightEpisodesCell
            } else {
                height = (self.aniEpisodesView.count/numberEpisodes + 1)*heightEpisodesCell
            }
        } else {
            height = heightEpisodesCell*numberRowEpisodes
        }
        
        return .init(width: CGFloat(width), height:  CGFloat(height))
    }
}
