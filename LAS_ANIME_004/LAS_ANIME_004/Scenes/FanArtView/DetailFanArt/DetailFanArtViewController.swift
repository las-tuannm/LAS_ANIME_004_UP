//
//  DetailFanArtViewController.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class DetailFanArtViewController: BaseViewController {

    //MARK: - Outlet
    @IBOutlet weak var detailImageView: UIImageView!
    
    //MARK: - Property
    var url: String!
    var viewModel: FanArtViewModel!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    //MARK: - Private
    private func setUpUI() {
        guard let url = url else {
            return
        }
        
        detailImageView.setImage(url, nil)
    }
    
    private func savePhotos() {
        guard let image = detailImageView.image else {
            Toast.show("Failed load image!")
            return
        }
        
        viewModel.saveToPhotos(image)
            .drive(onNext: {
                Toast.show("Saved")
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Action
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func downloadClick(_ sender: Any) {
        self.requestPermissionAccessPhotos { [weak self] isEnable in
            if isEnable {
                DispatchQueue.main.async {
                    self?.savePhotos()
                }
                
            } else {
                if !UserDefaults.hasBeenShowNoticeAccessPhoto {
                    UserDefaults.hasBeenShowNoticeAccessPhoto = true
                } else {
                    self?.showAlertOpenSettingPhotos()
                }
            }
        }
    }
}
