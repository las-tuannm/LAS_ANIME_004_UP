//
//  ArtItemCell.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 09/10/2023.
//

import UIKit

class ArtItemCell: UICollectionViewCell {

    @IBOutlet weak var artImageView: UIImageView!
    
    var url: String? {
        didSet {
            if let url = url {
                artImageView.setImage(url, nil)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}
