//
//  HomeContinueCell.swift
//  Anime9Main
//
//  Created by quang on 26/10/2023.
//

import UIKit

class HomeContinueCell: BaseCollectionCell {
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
        view.text = "Recently Watching"
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
        view.registerItem(cell: HomeContinueItemCell.self)
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
    var data: [RecentAni] = [] {
        didSet {
            if data.count > 0 {
                loadingView.stopAnimating()
                loadingView.isHidden = true
                
                listCollectionView.reloadData()
            }
        }
    }
    
    var onSelected: ((RecentAni) -> Void)?
}

extension HomeContinueCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeContinueItemCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.recentAni = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelected?(data[indexPath.row])
    }
}

extension HomeContinueCell: UICollectionViewDelegateFlowLayout {
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
        return HomeContinueItemCell.size(height: collectionView.size.height)
    }
}
