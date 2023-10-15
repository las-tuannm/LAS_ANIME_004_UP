//
//  ShortViewController.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class ShortViewController: BaseViewController {

    //MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Property
    var viewModel: ShortViewModel!
    var animeShorts = BehaviorRelay<[AnimeShortModel]>(value: [])
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        bindViewModel()
    }
    
    //MARK: - Private
    private func setUpUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ShortItemCell.nibClass, forCellWithReuseIdentifier: ShortItemCell.nibNameClass)
    }
    
    func bindViewModel() {
        trackShowToastError(viewModel)
        let input = ShortViewModel.Input(loadTrigger: .just(()))
        
        let output = viewModel.transform(input)
        
        output.animeShorts
            .drive(onNext: { [weak self] data in
                self?.animeShorts.accept(data)
            })
            .disposed(by: disposeBag)
        
        animeShorts.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func openYouTubeVideoInApp(withVideoID videoID: String) {
        let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(videoID)")!
        let safariViewController = SFSafariViewController(url: youtubeURL)
        present(safariViewController, animated: true, completion: nil)
    }
}

//MARK: - Extension UICollectionViewDataSource
extension ShortViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animeShorts.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortItemCell.nibNameClass, for: indexPath) as! ShortItemCell
        cell.configure(animeShorts.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = animeShorts.value[indexPath.row].video
        openYouTubeVideoInApp(withVideoID: GithubService.shared.getId(url: url))
    }
}

//MARK: - Extension UICollectionViewDelegate
extension ShortViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: padding, bottom: 20, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - padding * 2  - (columns - 1) * 14) / columns
        let height = width * 322 / 175
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}
