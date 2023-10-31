//
//  ChooseSpeedView.swift
//  Anime9Main
//
//  Created by Quynh Nguyen on 12/10/2023.
//

import UIKit

class ChooseSpeedView: UIView {
    
    var onRateChanged: ((_ value: Float) -> Void)?
    var onTimmingChanged: ((_ value: Int) -> Void)?
    
    var rate: Float {
        get {
            if var s = playbackSegment.titleForSegment(at: playbackSegment.selectedSegmentIndex) {
                s = s.replacingOccurrences(of: "x", with: "")
                return Float(s) ?? 1.0
            }
            return 1.0
        }
    }
    
    var timing: Int {
        get {
            return Int(timingSlider.value)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Speed"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white.withAlphaComponent(0.6)
        label.text = "You are running at rate 1.0x and the subtitle timing is 0 secods."
        label.font = UIFont.italicSystemFont(ofSize: 14)
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.getImage("ic-close-white"), for: .normal)
        return button
    }()
    
    private let playbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Playback speed"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let playbackSegment: UISegmentedControl = {
        let items: [String] = ["0.25x", "0.5x", "0.75x", "1.0x", "1.25x", "1.5x", "1.75x", "2.0x"]
        let seg = UISegmentedControl(items: items)
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.selectedSegmentIndex = 3    // 1.0x
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                   for: .selected)
        
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)],
                                   for: .normal)
        
        if #available(iOS 13.0, *) {
            seg.selectedSegmentTintColor = .init(rgb: 0xA74BFA)
        }
        
        seg.backgroundColor = .init(rgb: 0xA74BFA).withAlphaComponent(0.11)
        return seg
    }()
    
    private let timingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Subtitle timing"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let timingSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -30.0
        slider.maximumValue = 30.0
        slider.value = 0.0
        
        let image = UIImage.getImage("slider-thumb")?.sd_tintedImage(with: UIColor.init(rgb: 0xBB52FF))
        slider.setThumbImage(image, for: .normal)
        slider.minimumTrackTintColor = UIColor(rgb: 0x932EFF)
        slider.maximumTrackTintColor = UIColor(rgb: 0xD8D8D8)
        return slider
    }()
    
    private let timingMinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.text = "-30s"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let timingMidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0s"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let timingMaxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        label.text = "+30s"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .init(rgb: 0x050506)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        closeButton.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        playbackSegment.addTarget(self, action: #selector(playbackValueChanged), for: .valueChanged)
        timingSlider.addTarget(self, action: #selector(timingValueChanged), for: .valueChanged)
        
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(closeButton)
        addSubview(playbackLabel)
        addSubview(playbackSegment)
        
        addSubview(timingLabel)
        addSubview(timingSlider)
        addSubview(timingMinLabel)
        addSubview(timingMidLabel)
        addSubview(timingMaxLabel)
        
        closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        detailLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        playbackLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        playbackLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 30).isActive = true
        playbackLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        playbackLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        playbackSegment.leftAnchor.constraint(equalTo: playbackLabel.rightAnchor, constant: 20).isActive = true
        playbackSegment.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        playbackSegment.topAnchor.constraint(equalTo: playbackLabel.topAnchor).isActive = true
        playbackSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timingLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        timingLabel.topAnchor.constraint(equalTo: playbackLabel.bottomAnchor, constant: 30).isActive = true
        timingLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        timingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timingSlider.leftAnchor.constraint(equalTo: timingLabel.rightAnchor, constant: 20).isActive = true
        timingSlider.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        timingSlider.topAnchor.constraint(equalTo: timingLabel.topAnchor).isActive = true
        timingSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timingMinLabel.leftAnchor.constraint(equalTo: timingSlider.leftAnchor).isActive = true
        timingMinLabel.topAnchor.constraint(equalTo: timingSlider.bottomAnchor).isActive = true
        timingMinLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        timingMinLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        timingMidLabel.centerXAnchor.constraint(equalTo: timingSlider.centerXAnchor).isActive = true
        timingMidLabel.topAnchor.constraint(equalTo: timingSlider.bottomAnchor).isActive = true
        timingMidLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        timingMidLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        timingMaxLabel.rightAnchor.constraint(equalTo: timingSlider.rightAnchor).isActive = true
        timingMaxLabel.topAnchor.constraint(equalTo: timingSlider.bottomAnchor).isActive = true
        timingMaxLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        timingMaxLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func updateDetailInfo() {
        detailLabel.text = "You are running at rate \(rate)x and the subtitle timing is \(timing) secods."
    }
    
    func show() {
        guard let window = ApplicationHelper.shared.window() else { return }
        
        updateDetailInfo()
        
        let paView = UIView(frame: window.bounds)
        paView.alpha = 0
        paView.backgroundColor = .black.withAlphaComponent(0.3)
        window.addSubview(paView)
        
        let w: CGFloat = window.bounds.size.width
        let h: CGFloat = 250
        let x: CGFloat = 0
        let y: CGFloat = window.bounds.size.height - h
        
        frame = .init(x: x, y: y, width: w, height: h)
        alpha = 0
        paView.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            paView.alpha = 1
            self.alpha = 1
        } completion: { _ in
            
        }
    }
    
    @objc func closeClicked() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn) {
            self.superview?.alpha = 0
            self.alpha = 0
        } completion: { _ in
            self.superview?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    @objc func playbackValueChanged(_ sender: UISegmentedControl) {
        updateDetailInfo()
        onRateChanged?(rate)
    }
    
    @objc func timingValueChanged(_ sender: UISlider) {
        sender.value = Float(Int(sender.value))
        
        updateDetailInfo()
        onTimmingChanged?(Int(sender.value))
    }
}
