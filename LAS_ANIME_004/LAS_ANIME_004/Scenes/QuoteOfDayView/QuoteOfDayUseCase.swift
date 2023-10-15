//
//  QuoteOfDayUseCase.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import Foundation
import RxSwift

protocol QuoteOfDayUseCaseType {
    func getQuoteOfDay() -> Single<AnimeQuoteDayModel>
}

struct QuoteOfDayUseCase: QuoteOfDayUseCaseType {
    
    func getQuoteOfDay() -> Single<AnimeQuoteDayModel> {
        return GithubService.shared.getAnimeQuoteDay()
    }
}
