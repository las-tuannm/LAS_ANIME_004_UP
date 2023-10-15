//
//  AnimeQuoteUseCase.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import Foundation
import RxSwift

protocol AnimeQuoteUseCaseType {
    func getAnimeQuotes() -> Single<AnimeQuoteModel>
}

struct AnimeQuoteUseCase: AnimeQuoteUseCaseType {
    
    func getAnimeQuotes() -> Single<AnimeQuoteModel> {
        return GithubService.shared.getAnimeQuote()
    }
}
