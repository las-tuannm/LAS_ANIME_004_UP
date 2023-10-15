//
//  FanArtViewModel.swift
//  Tanqin
//
//  Created by HaKT on 05/10/2023.
//

import Foundation
import RxSwift
import RxCocoa
import Photos

class FanArtViewModel: BaseViewModel {
    private var service: FanArtUseCase
    init(useCase: FanArtUseCase) {
        self.service = useCase
    }
    
    func transform(_ input: Input) -> Output {
        
        let fanArt1 = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<FanArtModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.service.getFanArtOnePiece()
                    .asDriverOnErrorJustComplete()
            }
        
        let fanArt2 = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<FanArtModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.service.getFanArtGintama()
                    .asDriverOnErrorJustComplete()
            }
        
        let fanArt3 = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<FanArtModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.service.getFanArtNisekoi()
                    .asDriverOnErrorJustComplete()
            }
        
        let fanArt4 = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<FanArtModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.service.getFanArtVocaloid()
                    .asDriverOnErrorJustComplete()
            }
        
        let fanArt5 = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<FanArtModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.service.getFanArtHonkaiTag()
                    .asDriverOnErrorJustComplete()
            }

        let fanArt6 = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<FanArtModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.service.getFanArtOshiNoKo()
                    .asDriverOnErrorJustComplete()
            }
        
        let fanArt7 = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<FanArtModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.service.getFanArtJujutsuKaisen()
                    .asDriverOnErrorJustComplete()
            }
        
        let fanArt8 = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<FanArtModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.service.getFanArtSukiNaKoGa()
                    .asDriverOnErrorJustComplete()
            }
        
        
        let combinedResults = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<[FanArtModel]> in
                guard let self = self else {
                    return .empty()
                }
                return Driver.combineLatest(fanArt1, fanArt2, fanArt3, fanArt4, fanArt5, fanArt6, fanArt7, fanArt8) {
                    return [$0, $1, $2, $3, $4, $5, $6, $7]
                }
                .trackError(errorTracker)
                .trackActivity(loading)
                .asDriverOnErrorJustComplete()
            }
        
        return Output(fanArt: combinedResults)
    }
    
    func saveToPhotos(_ image: UIImage) -> Driver<Void> {
        return save(image)
            .trackError(errorTracker)
            .trackActivity(loading)
            .asDriverOnErrorJustComplete()
    }
    
    private func save(_ image: UIImage) -> Single<Void> {
        return Single.create { single in
            PHPhotoLibrary.shared().performChanges({
                let imageRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                imageRequest.creationDate = Date() // Set creation date of the image asset, if needed
            }, completionHandler: { (success, error) in
                if error != nil  {
                    single(.failure(error!))
                } else {
                    single(.success(()))
                }
            })
            return Disposables.create()
        }
    }
}

extension FanArtViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let fanArt: Driver<[FanArtModel]>
    }
}
