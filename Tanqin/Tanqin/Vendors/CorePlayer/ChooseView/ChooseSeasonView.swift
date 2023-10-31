import UIKit

fileprivate let _padding: CGFloat = 10
fileprivate let _columns: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 5 : 4

protocol ChooseSeasonDelegate: NSObject {
    func selectEpisode(episode: AniEpisodesModel)
}

class ChooseSeasonView: UIView {
    
    public weak var delegate: ChooseSeasonDelegate?
    
    public var episodes: [AniEpisodesModel] = [] {
        didSet {
            if self.typeSort == 0 {
                self.episodesView = self.episodes
            } else {
                self.episodesView = self.episodes.reversed()
            }
            listEpisode.reloadData()
            
        }
    }
    
    var episodesView: [AniEpisodesModel] = []
    
    public var episodeId: String = "" {
        didSet { listEpisode.reloadData() }
    }
    var typeSort: Int = 0
    var nameAnime: String = "" {
        didSet { nameLabel.text = nameAnime }
    }
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.getImage("ic-close-white"), for: .normal)
        return button
    }()
    
    fileprivate let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 20)
        view.textColor = .white
        view.text = ""
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let listEpisode: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: _padding, bottom: 0, right: _padding)
        layout.minimumLineSpacing = _padding
        layout.minimumInteritemSpacing = _padding
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.alwaysBounceVertical = true
        collection.registerItem(cell: ChooseSeasonCell.self)
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .init(rgb: 0x050506)
        layer.cornerRadius = 10
        clipsToBounds = true
        nameLabel.text = nameAnime
        closeButton.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)

        listEpisode.delegate = self
        listEpisode.dataSource = self
        
        addSubview(closeButton)
        addSubview(nameLabel)
        addSubview(listEpisode)
        
        closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -16).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        listEpisode.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        listEpisode.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10).isActive = true
        listEpisode.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        listEpisode.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func show() {
        guard let window = ApplicationHelper.shared.window() else { return }
        
        frame = window.bounds
        alpha = 0
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { _ in
            //self.reloadData()
        }
    }
    
    @objc func closeClicked() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

extension ChooseSeasonView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodesView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChooseSeasonCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.aniEpisodesModel = episodesView[indexPath.row]
        cell.episodeId = self.episodeId
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let epi = episodesView[indexPath.row]
        self.delegate?.selectEpisode(episode: epi)
    }
}

extension ChooseSeasonView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.frame.size.width
        return .init(width: Int(w)/numberEpisodesPlayer, height: heightEpisodesCell)
    }
}

class CustomizeCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet { bounce(isHighlighted) }
    }
    
    func bounce(_ bounce: Bool) {
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: { self.transform = bounce ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity },
            completion: nil)
        
    }
}
