//
//  QuoteOfDayUseCase.swift
//  Tanqin
//
//  Created by HaKT on 05/10/2023.
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
