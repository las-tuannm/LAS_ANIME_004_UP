//
//  ViewAllFanArtViewController.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 09/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class ViewAllFanArtViewController: BaseViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fanArtCollectionView: UICollectionView!
    
    //MARK: - Property
    var fanArts = BehaviorRelay<FanArtModel>(value: FanArtModel(status: "", tag: "", data: []))
    let column: CGFloat = UIDevice.current.is_iPhone ? 3 : 5
    let pad: CGFloat = UIDevice.current.is_iPhone ? 20 : 40
    let space: CGFloat = UIDevice.current.is_iPhone ? 7 : 14
    var viewModel: FanArtViewModel!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        driveUI()
    }
    
    deinit {
        SDImageCache.shared.clearMemory()
    }
    
    //MARK: - Private
    private func setUpUI() {
        fanArtCollectionView.delegate = self
        fanArtCollectionView.dataSource = self
        fanArtCollectionView.register(ArtItemCell.nibClass, forCellWithReuseIdentifier: ArtItemCell.nibNameClass)
        
    }
    
    func driveUI() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.pop()
            })
            .disposed(by: disposeBag)
        
        fanArts.asDriver()
            .drive(onNext: { [weak self] data in
                self?.fanArtCollectionView.reloadData()
                self?.titleLabel.text = data.tag
            })
            .disposed(by: disposeBag)
    }

    private func goToDetailImage(url: String) {
        let vc = DetailFanArtViewController()
        vc.url = url
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

//MARK: - Extension UICollectionViewDataSource
extension ViewAllFanArtViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fanArts.value.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtItemCell.cellId, for: indexPath) as! ArtItemCell
        cell.url = fanArts.value.data[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = fanArts.value.data[indexPath.row].image else {
            Toast.show("Image nout found!")
            return
        }
        goToDetailImage(url: urlString)
    }
}

//MARK: - Extension UICollectionViewDelegate
extension ViewAllFanArtViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - pad * 2 - space * (column - 1)) / column
        let heigh = width * 160 / 114
        return CGSize(width: width, height: heigh)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: pad, bottom: pad, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
}
