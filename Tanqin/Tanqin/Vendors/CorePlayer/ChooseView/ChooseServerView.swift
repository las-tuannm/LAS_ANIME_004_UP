import UIKit

fileprivate let _padding: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 10
fileprivate let _columns: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 6 : 3

class ChooseServerView: UIView {
    fileprivate var source: [FileSVModel] = []
    
    var data: [VideoIntentModel] = [] {
        didSet {
            source.removeAll()
            for item in data {
                source += item.sources
            }
            titleLabel.text = "Choose a server (\(source.count) servers)"
            collectionView.reloadData()
        }
    }
    
    var fileSvSelected: FileSVModel? {
        didSet { collectionView.reloadData() }
    }
    
    var onSelected: ((_ data: FileSVModel, _ tracks: [SubtitleModel]) -> Void)? = nil
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Choose a server"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.getImage("ic-close-white"), for: .normal)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.alwaysBounceVertical = true
        collection.registerItem(cell: ChooseServerCell.self)
        return collection
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(collectionView)
        
        closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        closeButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func show() {
        guard let window = ApplicationHelper.shared.window() else { return }
        
        frame = window.bounds
        alpha = 0
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { _ in
            
        }
    }
    
    @objc func closeClicked() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
}

extension ChooseServerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChooseServerCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.fileSv = source[indexPath.row]
        cell.fileSvSelected = self.fileSvSelected
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fi = source[indexPath.row]
        for item in data {
            for s in item.sources {
                if s == fi {
                    onSelected?(fi, item.tracks)
                    closeClicked()
                    return
                }
            }
        }
    }
}

extension ChooseServerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return _padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return _padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = ((collectionView.frame.size.width - (_columns + 1) * _padding) / _columns).rounded(.down)
        return .init(width: w, height: 60)
    }
}
