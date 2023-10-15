//
//  ShortUseCase.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
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
