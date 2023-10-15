//
//  ShortUseCase.swift
//  Tanqin
//
//  Created by HaKT on 05/10/2023.
//

import Foundation
import RxSwift

protocol ShortUseCaseType {
    func getAnimeShorts() -> Single<AnimeShortsModel>
}

struct ShortUseCase: ShortUseCaseType {
    
    func getAnimeShorts() -> Single<AnimeShortsModel> {
        return GithubService.shared.getAnimeShort()
    }
}
