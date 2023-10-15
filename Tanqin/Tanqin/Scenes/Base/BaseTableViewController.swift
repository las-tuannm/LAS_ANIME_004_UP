//
//  BaseTableViewController.swift
//  Tanqin
//
//  Created by HaKT on 06/07/2022.
//

import Foundation
import MJRefresh
import RxSwift

class BaseTableViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var viewModel: BaseViewModel
    
    let afterBindingViewModelTrigger = PublishSubject<Void>()
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerLoadMoreTrigger = PublishSubject<Void>()
    
    let isEnableLoadMore = PublishSubject<Bool>()
    private let isHeaderLoading = PublishSubject<Bool>()
    private let isFooterLoading = PublishSubject<Bool>()
    
    init(viewModel: BaseViewModel? = nil) {
        self.viewModel = viewModel ?? BaseViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderFooterView()
        bindViewModel()
        afterBindingViewModelTrigger.onNext(())
    }
    
    func tableViewHeader() -> MJRefreshHeader? {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        })
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        return header
    }
    
    func tableViewFooter() -> MJRefreshFooter? {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.footerLoadMoreTrigger.onNext(())
        })
        footer.setTitle("", for: .noMoreData)
        footer.setTitle("", for: .willRefresh)
        footer.setTitle("", for: .pulling)
        footer.setTitle("", for: .refreshing)
        footer.setTitle("", for: .idle)
        footer.isRefreshingTitleHidden = true
        return footer
    }
    
    private func setupHeaderFooterView() {
        tableView.tableFooterView = UIView()
        tableView.mj_header = tableViewHeader()
        tableView.mj_footer = tableViewFooter()
    }
    
    func bindViewModel() {
        isHeaderLoading.bind(to: isAnimatingHeader).disposed(by: disposeBag)
        isHeaderLoading.filter({ $0 }).bind(to: isEnableLoadMore).disposed(by: disposeBag)
        isEnableLoadMore.bind(to: isEnableLoadMoreBinder).disposed(by: disposeBag)
        
        Observable.combineLatest(
            isFooterLoading,
            isEnableLoadMore
        ) { value, isEnable in
            return isEnable ? value : nil
        }
        .compactMap({ $0 })
        .asDriverOnErrorJustComplete()
        .drive(isAnimatingFooter)
        .disposed(by: disposeBag)
        
        viewModel
            .headerLoading
            .asDriver()
            .drive(isHeaderLoading)
            .disposed(by: disposeBag)
        
        viewModel
            .footerLoading
            .asDriver()
            .drive(isFooterLoading)
            .disposed(by: disposeBag)
    }
    
}

private extension BaseTableViewController {
    var isEnableLoadMoreBinder: Binder<Bool> {
        return Binder(self) { viewController, enable in
            if enable {
                viewController.tableView.mj_footer?.resetNoMoreData()
            } else {
                viewController.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
    }
    
    var isAnimatingHeader: Binder<Bool> {
        return Binder(self) { viewController, loading in
            guard !loading else { return }
            viewController.tableView.mj_header?.endRefreshing()
        }
    }
    
    var isAnimatingFooter: Binder<Bool> {
        return Binder(self) { viewController, loading in
            guard !loading else { return }
            viewController.tableView.mj_footer?.endRefreshing()
        }
    }
}
