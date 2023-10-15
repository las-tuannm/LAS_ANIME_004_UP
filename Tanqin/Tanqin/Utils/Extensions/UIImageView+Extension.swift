//
//  Extension+UIImageView.swift
//  Tanqin
//
//  Created by HaKT on 27/09/2023.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func setImage(_ urlStr: String, _ placeholder: UIImage?) {
        guard let url = URL(string: urlStr) else {
            return
        }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, placeholderImage: placeholder)
    }
    
    func setImage(_ url: URL, _ placeholder: UIImage?) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, placeholderImage: placeholder)
    }
}
