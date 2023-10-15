//
//  QuoteOfDayViewModel.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class QuoteOfDayViewModel: BaseViewModel {
    private var service: QuoteOfDayUseCase
    
    init(useCase: QuoteOfDayUseCase) {
        self.service = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let quoteDay = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<AnimeQuoteDayModel> in
                guard let self = self else {
                    return .never()
                }
                return self.service.getQuoteOfDay()
                    .trackError(self.errorTracker)
                    .trackActivity(self.loading)
                    .share(replay: 1, scope: .forever)
                    .asDriverOnErrorJustComplete()
                    
            }
        return Output(quoteDay: quoteDay)
    }
}

extension QuoteOfDayViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let quoteDay: Driver<AnimeQuoteDayModel>
    }
}
