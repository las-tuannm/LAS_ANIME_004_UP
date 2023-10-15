//
//  AnimeQuoteUseCase.swift
//  Tanqin
//
//  Created by HaKT on 05/10/2023.
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
