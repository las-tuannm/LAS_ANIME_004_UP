//
//  ColorCell.swift
//  Anime9Main
//
//  Created by quang on 13/10/2023.
//

import UIKit
import SnapKit

class ColorCell: BaseCollectionCell {
    fileprivate let viewBoder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let viewColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.drawUIs()
    }
    
    private func drawUIs() {
        contentView.backgroundColor = .clear
        contentView.addSubview(viewBoder)
        viewBoder.addSubview(viewColor)
        viewBoder.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        viewColor.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(3)
            make.trailing.bottom.equalToSuperview().offset(-3)
        }
    }
    
    var color: Int = 0xffffff {
        didSet {
            viewColor.backgroundColor = UIColor(rgb: color)
            if color == AppInfo.getSubTitleColor(){
                viewBoder.layer.borderWidth = 1
                viewBoder.layer.borderColor = UIColor(rgb: 0xEA001E).cgColor
            } else {
                viewBoder.layer.borderWidth = 0
                viewBoder.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
