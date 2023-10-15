//
//  AnimeQuoteViewModel.swift
//  Tanqin
//
//  Created by HaKT on 05/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class AnimeQuoteViewModel: BaseViewModel {
    private var service: AnimeQuoteUseCase
    
    init(useCase: AnimeQuoteUseCase) {
        self.service = useCase
    }
    
    func transform(_ input: Input) -> Output {
        
        let quotes = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<[AnimeQuoteDayModel]> in
                guard let self = self else {
                    return .never()
                }
                return self.service.getAnimeQuotes()
                    .trackError(self.errorTracker)
                    .trackActivity(self.loading)
                    .map({ animeQuote in
                        return animeQuote.data
                    })
                    .share(replay: 1, scope: .forever)
                    .asDriverOnErrorJustComplete()
            }
        
        return Output(animeQuotes: quotes)
    }
}

extension AnimeQuoteViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let animeQuotes: Driver<[AnimeQuoteDayModel]>
    }
}
