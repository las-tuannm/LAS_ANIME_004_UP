//
//  FanArtTableViewCell.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 06/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class FanArtTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var viewAllLabel: UILabel!
    @IBOutlet weak var artCollectionView: UICollectionView!
    @IBOutlet weak var seeAllButton: UIButton!
    
    let disposeBag = DisposeBag()
    var fanArts = BehaviorRelay<FanArtModel>(value: FanArtModel(status: "", tag: "", data: []))
    var seeAllButtonTapped: ((FanArtModel) -> Void)?
    var itemSelected: ((String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if fanArts.value.data.count > 0 {
            artCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        }
    }
    
    //MARK: - Private
    func setUpUI() {
        viewAllLabel.textColor = .colorFF491F
        artCollectionView.delegate = self
        artCollectionView.dataSource = self
        artCollectionView.register(ArtItemCell.nibClass, forCellWithReuseIdentifier: ArtItemCell.nibNameClass)
        
        seeAllButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let fanArtModel = self?.fanArts.value {
                    self?.seeAllButtonTapped?(fanArtModel)
                }
            })
            .disposed(by: disposeBag)
        
        fanArts.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.artCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func configure(_ item: FanArtModel) {
        fanArts.accept(item)
        categoryLabel.text = item.tag
    }
}

//MARK: - Extension UICollectionViewDataSource
extension FanArtTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fanArts.value.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtItemCell.cellId, for: indexPath) as! ArtItemCell
        cell.url = fanArts.value.data[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = fanArts.value.data[indexPath.row].image
        itemSelected?(url)
    }
}

//MARK: - Extension UICollectionViewDelegate
extension FanArtTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 130 / 185
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
