//
//  BaseViewModel.swift
//  Tanqin
//
//  Created by HaKT on 27/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    var errorMsg    = PublishRelay<String>()
    var errorAppCode   = PublishRelay<Int>()
    var disposeBag  = DisposeBag()
    let progress    = ActivityIndicatorUtility()
    
    let errorTracker: ErrorTracker
    let loading         = ActivityIndicator()
    let headerLoading   = ActivityIndicator()
    let footerLoading   = ActivityIndicator()
    let reachabilityManager = ReachabilityManager.shared

    init() {
        errorTracker = ErrorTracker()
        errorTracker.asObservable().subscribe(onNext: { [weak self] (error) in
            self?.handleError(error)
            
        }).disposed(by: disposeBag)
        
        loading.asObservable()
            .bind(to: progress.rx_progresshud_animating)
            .disposed(by: disposeBag)
    }
    func handleError(_ error: Error) {
        if let error = error as? AppError {
            if !error.message.isEmpty {
                errorMsg.accept(error.message)
            } else {
//                errorAppCode.accept(error.code)
                errorMsg.accept("Constants.L10n.commonErrorText")
            }
            errorAppCode.accept(error.code)
        }
        else if let error = error as? RxSwift.RxError {
            switch error {
            case .timeout:
                errorMsg.accept("Constants.L10n.commonErrorTimeoutText")
            default:
                errorMsg.accept("Constants.L10n.commonErrorText")
            }
        }
        else {
            errorMsg.accept("Constants.L10n.commonErrorText")
        }
    }
}
