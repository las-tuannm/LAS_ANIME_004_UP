//
//  FanArtViewController.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class FanArtViewController: BaseViewController {

    //MARK: - Outlet
    @IBOutlet weak var fanArtTableView: UITableView!
    
    //MARK: - Property
    var viewModel: FanArtViewModel!
    let category = BehaviorRelay<[FanArtModel]>(value: [])
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        bindViewModel()
    }
    
    //MARK: - Private
    private func setUpUI() {
        fanArtTableView.delegate = self
        fanArtTableView.dataSource = self
        fanArtTableView.register(FanArtTableViewCell.nibClass, forCellReuseIdentifier: FanArtTableViewCell.nibNameClass)
        fanArtTableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
    }
    
    private func bindViewModel() {
        trackShowToastError(viewModel)
        let input = FanArtViewModel.Input(loadTrigger: .just(()))
        let output = viewModel.transform(input)
        
        output.fanArt
            .drive(onNext: { [weak self] data in
                self?.category.accept(data)
            })
            .disposed(by: disposeBag)
        
        category.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.fanArtTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func goToViewAll(data: FanArtModel) {
        let vc = ViewAllFanArtViewController()
        vc.fanArts.accept(data)
        vc.viewModel = viewModel
        push(vc)
    }
    
    private func goToDetailImage(url: String) {
        let vc = DetailFanArtViewController()
        vc.url = url
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

//MARK: Extension UITableView
extension FanArtViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FanArtTableViewCell.cellId) as! FanArtTableViewCell
        cell.configure(category.value[indexPath.row])
        cell.seeAllButtonTapped = { [weak self] data in
            self?.goToViewAll(data: data)
        }
        
        cell.itemSelected = { [weak self] urlString in
            if let urlString = urlString {
                self?.goToDetailImage(url: urlString)
            }
        }
        return cell
    }
}
