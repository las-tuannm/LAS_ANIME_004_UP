//
//  LoadingView.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 31/10/2023.
//

import UIKit
import Lottie
import SnapKit

class LoadingView: UIView {
    private let animationView = LottieAnimationView(name: "anime_loading")
    private let contentView = PView()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.medium(of: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Loading..."
        return label
    }()
    
    // MARK: init
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
        initSubviews()
        initConstraint()
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComponent()
        initSubviews()
        initConstraint()
    }
    
    // MARK: dealloc
    deinit { }
    
    // MARK: private
    private func initComponent() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.cornerRadius = 16
        animationView.backgroundColor = UIColor.clear
        animationView.contentMode = .scaleAspectFit
    }
    
    private func initSubviews() {
        self.addSubview(contentView)
        self.contentView.addSubview(animationView)
        self.contentView.addSubview(messageLabel)
    }
    
    private func initConstraint() {
        self.contentView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(CGSize(width: 100, height: 140))
        }
        animationView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.top.equalToSuperview().offset(0)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.size.equalTo(CGSize(width: 150, height: 40))
            make.bottom.equalToSuperview().offset(0)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    // MARK: public
    func show() {
        DispatchQueue.main.async {
            self.showIn(nil)
        }
    }
    
    func showIn(_ view: UIView? = nil) {
        if let v = view {
            self.frame = v.bounds
            v.addSubview(self)
        }
        else {
            guard let window = UIWindow.keyWindow else { return }
            self.frame = window.bounds
            window.addSubview(self)
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop,
                           completion: { (finished) in})
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (success) in
                self.animationView.stop()
                self.removeFromSuperview()
            }
        }
    }
}

