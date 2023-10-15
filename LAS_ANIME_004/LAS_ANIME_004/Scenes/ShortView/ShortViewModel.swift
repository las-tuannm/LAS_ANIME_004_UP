//
//  ShortViewModel.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class ShortViewModel: BaseViewModel {
    private var service: ShortUseCase
    init(useCase: ShortUseCase) {
        self.service = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let shorts = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<[AnimeShortModel]> in
                guard let self = self else {
                    return .never()
                }
                return self.service.getAnimeShorts()
                    .trackError(self.errorTracker)
                    .trackActivity(self.loading)
                    .map({ shorts in
                        return shorts.data
                    })
                    .share(replay: 1, scope: .forever)
                    .asDriverOnErrorJustComplete()
            }
        
        return Output(animeShorts: shorts)
    }
}

extension ShortViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let animeShorts: Driver<[AnimeShortModel]>
    }
}
