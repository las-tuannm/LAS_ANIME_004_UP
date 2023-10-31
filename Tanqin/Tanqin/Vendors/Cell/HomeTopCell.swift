import UIKit
import SnapKit

class HomeTopCell: BaseCollectionCell {
    // MARK: - override from supper view
    override class func size(width: CGFloat = 0) -> CGSize {
        return .init(width: width, height: 268)
    }
    
    fileprivate let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 18)
        view.textColor = .white
        view.text = "Top Anime"
        return view
    }()
    
    fileprivate let viewTop: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(rgb: 0x0F1017)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // MARK: - properties
    fileprivate let titleTop: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(of: 12)
        view.textColor = .white
        view.text = "Day"
        view.textAlignment = .center
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate let titleWeek: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(of: 12)
        view.textColor = .white
        view.text = "Week"
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate let titleMonth: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(of: 12)
        view.textColor = .white
        view.text = "Month"
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate let listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.registerItem(cell: HomeTopAniware.self)
        view.registerItem(cell: HomeTop9Anime.self)
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
    
    // MARK: - private
    private func drawUIs() {
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        contentView.addSubview(viewTop)
        viewTop.addSubview(titleTop)
        viewTop.addSubview(titleWeek)
        viewTop.addSubview(titleMonth)
        contentView.addSubview(listCollectionView)

        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        
        viewTop.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(2)
            make.width.equalTo(158)
            make.height.equalTo(36)
        }
        
        titleMonth.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.width.equalTo(50)
            make.height.equalTo(28)
        }
        
        titleWeek.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalTo(self.titleMonth.snp.leading).offset(0)
            make.height.equalTo(28)
            make.width.equalTo(50)
        }
        
        titleTop.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalTo(self.titleWeek.snp.leading).offset(0)
            make.height.equalTo(28)
            make.width.equalTo(50)
        }

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().offset(0)
        }
        
        titleTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topClick)))
        titleWeek.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(weekClick)))
        titleMonth.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(monthClick)))
        
        setupAnimateLoadingView()
        
        self.typeTop = 0
        self.titleTop.backgroundColor = UIColor.init(rgb: 0xBB52FF)
        self.titleWeek.backgroundColor = UIColor.clear
        self.titleMonth.backgroundColor = UIColor.clear
        
    }
    
    @objc func topClick() {
        self.typeTop = 0
        self.titleTop.backgroundColor = UIColor.init(rgb: 0xBB52FF)
        self.titleWeek.backgroundColor = UIColor.clear
        self.titleMonth.backgroundColor = UIColor.clear
        self.listCollectionView.reloadData()
    }
    
    @objc func weekClick() {
        self.typeTop = 1
        self.titleTop.backgroundColor = UIColor.clear
        self.titleWeek.backgroundColor = UIColor.init(rgb: 0xBB52FF)
        self.titleMonth.backgroundColor = UIColor.clear
        self.listCollectionView.reloadData()
    }
    
    @objc func monthClick() {
        self.typeTop = 2
        self.titleTop.backgroundColor = UIColor.clear
        self.titleWeek.backgroundColor = UIColor.clear
        self.titleMonth.backgroundColor = UIColor.init(rgb: 0xBB52FF)
        self.listCollectionView.reloadData()
    }
    
    // MARK: - public
    var today: [AniModel] = []
    var week: [AniModel] = []
    var month: [AniModel] = []
    
    var typeTop = 0
    
    func setData(today: [AniModel], week: [AniModel], month: [AniModel]) {
        self.today = today
        self.week = week
        self.month = month
        if typeTop == 0 {
            if today.count > 0 {
                loadingView.stopAnimating()
                loadingView.isHidden = true
                listCollectionView.reloadData()
            }
        } else if typeTop == 1 {
            if week.count > 0 {
                loadingView.stopAnimating()
                loadingView.isHidden = true
                listCollectionView.reloadData()
            }
        } else if typeTop == 2 {
            if month.count > 0 {
                loadingView.stopAnimating()
                loadingView.isHidden = true
                listCollectionView.reloadData()
            }
        }
    }
    
    var onSelected: ((AniModel) -> Void)?

}

extension HomeTopCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if typeTop == 0 {
            return min(today.count, kMaxItemDisplay)
        } else if typeTop == 1 {
            return min(week.count, kMaxItemDisplay)
        } else if typeTop == 2 {
            return min(month.count, kMaxItemDisplay)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if HTMLService.shared.getSourceAnime() == .anime9 {
            let cell: HomeTop9Anime = collectionView.dequeueReusableCell(indexPath: indexPath)
            if typeTop == 0 {
                cell.aniModel = today[indexPath.row]
            } else if typeTop == 1 {
                cell.aniModel = week[indexPath.row]
            } else if typeTop == 2 {
                cell.aniModel = month[indexPath.row]
            }
            cell.index = indexPath.row
            return cell
        } else {
            let cell: HomeTopAniware = collectionView.dequeueReusableCell(indexPath: indexPath)
            if typeTop == 0 {
                cell.aniModel = today[indexPath.row]
            } else if typeTop == 1 {
                cell.aniModel = week[indexPath.row]
            } else if typeTop == 2 {
                cell.aniModel = month[indexPath.row]
            }
            cell.index = indexPath.row
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if typeTop == 0 {
            onSelected?(today[indexPath.row])
        } else if typeTop == 1 {
            onSelected?(week[indexPath.row])
        } else if typeTop == 2 {
            onSelected?(month[indexPath.row])
        }
    }
}

extension HomeTopCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 72)
    }
}
