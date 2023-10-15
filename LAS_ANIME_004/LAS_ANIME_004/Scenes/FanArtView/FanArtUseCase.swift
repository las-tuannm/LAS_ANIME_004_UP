//
//  FanArtUseCase.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import Foundation
import RxSwift

protocol FanArtUseCaseType {
    func getFanArtGintama() -> Single<FanArtModel>
    func getFanArtNisekoi() -> Single<FanArtModel>
    func getFanArtVocaloid() -> Single<FanArtModel>
    func getFanArtOnePiece() -> Single<FanArtModel>
    func getFanArtHonkaiTag() -> Single<FanArtModel>
    func getFanArtOshiNoKo() -> Single<FanArtModel>
    func getFanArtJujutsuKaisen() -> Single<FanArtModel>
    func getFanArtSukiNaKoGa() -> Single<FanArtModel>
}
    

struct FanArtUseCase: FanArtUseCaseType {
    
    func getFanArtGintama() -> Single<FanArtModel> {
        return GithubService.shared.getFanArtGintama()
    }
    
    func getFanArtNisekoi() -> Single<FanArtModel> {
        return GithubService.shared.getFanArtNisekoi()
    }
    
    func getFanArtVocaloid() -> Single<FanArtModel> {
        return GithubService.shared.getFanArtVocaloid()
    }
    
    func getFanArtOnePiece() -> Single<FanArtModel> {
        return GithubService.shared.getFanArtOnePiece()
    }
    
    func getFanArtHonkaiTag() -> Single<FanArtModel> {
        return GithubService.shared.getFanArtHonkaiTag()
    }
    
    func getFanArtOshiNoKo() -> Single<FanArtModel> {
        return GithubService.shared.getFanArtOshiNoKo()
    }
    
    func getFanArtJujutsuKaisen() -> Single<FanArtModel> {
        return GithubService.shared.getFanArtJujutsuKaisen()
    }
    
    func getFanArtSukiNaKoGa() -> Single<FanArtModel> {
        return GithubService.shared.getFanArtSukiNaKoGa()
    }
}
