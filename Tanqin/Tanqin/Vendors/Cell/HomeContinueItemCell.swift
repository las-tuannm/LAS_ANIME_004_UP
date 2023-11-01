//
//  HomeContinueItemCell.swift
//  Anime9Main
//
//  Created by quang on 26/10/2023.
//

import UIKit
import SDWebImage
import SnapKit

class HomeContinueItemCell: BaseCollectionCell {
    // MARK: - override from supper view
    override class func size(height: CGFloat = 0) -> CGSize {
        return .init(width: 125, height: 212)
    }
    
    // MARK: - properties
    
    fileprivate let viewInfo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb: 0x242424)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    fileprivate let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_thumb"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let imagePlay: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_play"))
        return view
    }()
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(of: 14)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        return view
    }()
    
    fileprivate let episodeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(of: 12)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        return view
    }()
    
    // MARK: - initital
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.drawUIs()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - private
    private func drawUIs() {
        contentView.backgroundColor = .clear
        contentView.addSubview(viewInfo)
        viewInfo.addSubview(imageView)
        viewInfo.addSubview(imagePlay)
        viewInfo.addSubview(episodeLabel)
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        viewInfo.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(0)
        }
        
        episodeLabel.snp.makeConstraints { make in
            make.leading.equalTo(4)
            make.bottom.equalTo(0)
            make.height.equalTo(26)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(episodeLabel.snp.top).offset(0)
        }
        
        imagePlay.snp.makeConstraints { make in
            make.center.equalTo(self.imageView.snp.center)
            make.width.height.equalTo(32)
        }
        
    }
    
    // MARK: - public
    var recentAni: RecentAni! {
        didSet {
            titleLabel.text = recentAni.enName
            episodeLabel.text = "Episode \(recentAni.episode)"
            imageView.sd_setImage(with: URL(string: recentAni.posterLink), placeholderImage: UIImage(named: "ic_thumb"))
        }
    }
}

