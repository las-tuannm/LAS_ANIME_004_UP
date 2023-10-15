//
//  AnimeQuoteCardView.swift
//  Tanqin
//
//  Created by HaKT on 06/10/2023.
//

import UIKit
import SnapKit

class AnimeQuoteCardView: UIView {
    
    lazy var avatar: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.backgroundColor = UIColor(hex: "#D8D8D8", alpha: 1)
        imv.setLayout(radius: 10, borderWidth: 1, borderColor: UIColor(hex: "#979797", alpha: 1))
        return imv
    }()
    
    lazy var animeNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .color242833
        lb.font = .balooBhaina2_Bold(ofSize: 16)
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var characterNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .color8B8B8B
        lb.font = .balooBhaina2_Regular(ofSize: 16)
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var quotesLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .color2E2E2E
        lb.font = .balooBhaina2_Regular(ofSize: 16)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    // MARK: - Init
    init(quoteURL: String, animeName: String, characterName: String, quotes: String) {
        super.init(frame: .zero)
        setUpUI()
        setUpData(quoteURL: quoteURL, animeName: animeName, characterName: characterName, quotes: quotes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -  Private
    private func setUpUI() {
        self.backgroundColor = .white
        layer.cornerRadius = 20
        setShadow(offset: CGSize(width: 0, height: 6), radius: 14, color: .black, opacity: 0.14)
        
        [avatar, animeNameLabel, characterNameLabel, quotesLabel].forEach { sub in
            addSubview(sub)
        }
        
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.width.equalTo(86)
            make.height.equalTo(122)
            make.centerX.equalToSuperview()
        }
        
        animeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(24)
            make.height.equalTo(24)
        }
        
        characterNameLabel.snp.makeConstraints { make in
            make.top.equalTo(animeNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
            make.leading.greaterThanOrEqualToSuperview().offset(24)
        }
        
        quotesLabel.snp.makeConstraints { make in
            make.top.equalTo(characterNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
            make.leading.greaterThanOrEqualToSuperview().offset(24)
        }
    }
    
    private func setUpData(quoteURL: String, animeName: String, characterName: String, quotes: String) {
        avatar.setImage(quoteURL, nil)
        animeNameLabel.text = animeName
        characterNameLabel.text = characterName
        quotesLabel.text = quotes
    }
}
