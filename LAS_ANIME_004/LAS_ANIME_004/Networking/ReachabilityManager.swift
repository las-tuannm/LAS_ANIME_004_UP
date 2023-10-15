//
//  ReachabilityManager.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 09/10/2023.
//

import RxSwift
import RxCocoa
import Reachability

class ReachabilityManager {
    
    static let shared = ReachabilityManager()
    
    private let reachability = try! Reachability()
    
    let networkStatus: BehaviorRelay<Bool> = BehaviorRelay(value: true) // Mặc định là true (có kết nối)
    private let disposeBag = DisposeBag()
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(_ notification: Notification) {
        networkStatus.accept(reachability.connection != .unavailable)
    }
}
