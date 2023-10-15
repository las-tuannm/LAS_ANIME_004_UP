//
//  AnimeQuoteViewController.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
//import Koloda

class AnimeQuoteViewController: BaseViewController {

    //MARK: - Outlet
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousView: UIView!
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    
    //MARK: - Property
    var viewModel: AnimeQuoteViewModel!
    var animeQuotes = BehaviorRelay<[AnimeQuoteDayModel]>(value: [])
    var cardIndex = BehaviorRelay<Int>(value: 0)
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        bindViewModel()
        

    }
    
    //MARK: - Private
    private func setUpUI() {
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.countOfVisibleCards = 2
        kolodaView.alphaValueSemiTransparent = 0.42
        kolodaView.backgroundCardsTopMargin = 14
        kolodaView.backgroundColor = .clear
        kolodaView.layer.cornerRadius = 20
        kolodaView.setShadow(offset: CGSize(width: 0, height: 6), radius: 14, color: .black, opacity: 0.14)
        
        nextLabel.textColor = .colorFF491F
        previousLabel.textColor = .colorFF491F
        
    }
    
    private func bindViewModel() {
        trackShowToastError(viewModel)
        let input = AnimeQuoteViewModel.Input(loadTrigger: .just(()))
        let output = viewModel.transform(input)
        
        output.animeQuotes
            .drive(onNext: { [weak self] data in
                guard let self = self else {
                    return
                }
                self.animeQuotes.accept(data)
            })
            .disposed(by: disposeBag)
        
        animeQuotes.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.kolodaView.reloadData()
                self.cardIndex.accept(0)
            })
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.kolodaView.revertAction(direction: .right)
                self.cardIndex.accept(self.kolodaView.currentCardIndex)
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.kolodaView.swipe(.right)
                self.cardIndex.accept(self.kolodaView.currentCardIndex)
            })
            .disposed(by: disposeBag)
        
        cardIndex.asObservable()
            .map{$0 > 0 ? 1.0 : 0.0}
            .bind(to: previousView.rx.alpha)
            .disposed(by: disposeBag)
        
        cardIndex.asObservable()
            .map{ [weak self] index in
                guard let self = self else {
                    return 0
                }
                return index < self.animeQuotes.value.count ? 1.0 : 0.0}
            .bind(to: nextView.rx.alpha)
            .disposed(by: disposeBag)
        
    }
}

//MARK: - extension KolodaViewDataSource
extension AnimeQuoteViewController: KolodaViewDataSource {
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let item = animeQuotes.value[index]
        let cardView = AnimeQuoteCardView(quoteURL: item.quoteURL, animeName: item.animeName, characterName: item.animeCharacter, quotes: item.quote)
        return cardView
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return animeQuotes.value.count
    }
}

//MARK: - extension KolodaViewDelegate
extension AnimeQuoteViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
}
