//
//  ShortItemCell.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 06/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ShortItemCell: UICollectionViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpUI()
    }
    
    private func setUpUI() {
        thumbImage.setLayout(radius: 20, borderWidth: 1, borderColor: .color979797)
        thumbImage.backgroundColor = .colorD8D8D8
        
        usernameLabel.textColor = .colorFF4E2F
    }

    func configure(_ item: AnimeShortModel) {
        postLabel.text = item.postTxt
        usernameLabel.text = item.username

        GithubService.shared.fetchYouTubeThumbnail(shortUrl: item.video) { url in
            guard let url = url else {
                return
            }
            DispatchQueue.main.async {
                self.thumbImage.setImage(url, nil)

            }
        }
    }
}
