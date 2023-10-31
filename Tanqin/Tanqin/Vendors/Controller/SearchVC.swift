import UIKit
import SnapKit

private enum SearchLayout {
    case type, genres
}

class SearchVC: BaseController, UITextFieldDelegate {

    fileprivate let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.registerItem(cell: SearchTypeItem.self)
        return view
    }()
    
    fileprivate let searchContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.09)
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let iconSearch: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic-search"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    fileprivate let searchTextField: MuTextField = {
        let view = MuTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 16)
        view.textColor = .white
        view.clearButtonMode = .whileEditing
        view.returnKeyType = .search
        view.attributedPlaceholder = NSAttributedString(
            string: "Search here...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5),
                         NSAttributedString.Key.font: UIFont.regular(of: 16) as Any]
        )
        return view
    }()
    
    fileprivate let titleCategory: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(of: 18)
        view.textColor = .white
        view.text = "Category"
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate let titleGenres: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(of: 14)
        view.textColor = .init(rgb: 0x959595)
        view.text = "Genres"
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var listType = [AniGenreModel]()
    var listGenres = [AniGenreModel]()
    
    var typeList = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        collectionView.delegate = self
        collectionView.dataSource = self

        searchTextField.delegate = self
        titleCategory.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categoryClick)))
        titleGenres.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(genresClick)))
        
        getData()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("change_source"), object: nil, queue: .main) { [unowned self] _ in
            self.getData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabbar = UIWindow.keyWindow?.mainTabbar1 {
            listGenres = tabbar.genres
            collectionView.reloadData()
        }
    }
    
    func getData(){
        listType = HTMLService.shared.getSourceAnime() == .anime9 ? HTMLService.shared.types() : AnWHTMLService.shared.types()
        collectionView.reloadData()
    }
    
    @objc func categoryClick() {
        self.typeList = 0
        self.titleCategory.font = UIFont.bold(of: 18)
        self.titleGenres.font = UIFont.regular(of: 14)
        self.titleCategory.textColor = .white
        self.titleGenres.textColor = .init(rgb: 0x959595)
        self.collectionView.reloadData()
    }
    
    @objc func genresClick() {
        self.typeList = 1
        self.titleCategory.font = UIFont.regular(of: 14)
        self.titleGenres.font = UIFont.bold(of: 18)
        self.titleCategory.textColor = .init(rgb: 0x959595)
        self.titleGenres.textColor = .white
        self.collectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let term = searchTextField.textString
        if !term.isEmpty {
            let vc = SearchDetailVC()
            vc.searchString = term
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return true
    }
    
    func initView(){
        self.view.addSubview(viewContent)
        self.viewContent.layoutSafeAreaEdges()
        self.viewContent.addSubview(collectionView)
        self.viewContent.addSubview(searchContainerView)
        
        self.viewContent.addSubview(titleCategory)
        self.viewContent.addSubview(titleGenres)
        
        self.searchContainerView.addSubview(iconSearch)
        self.searchContainerView.addSubview(searchTextField)
        
        self.searchContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(50)
        }
        
        self.iconSearch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.height.width.equalTo(20)
        }
        
        self.searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.iconSearch.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(31)
        }
        
        self.titleCategory.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.searchContainerView.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
        
        self.titleGenres.snp.makeConstraints { make in
            make.top.equalTo(self.searchContainerView.snp.bottom).offset(16)
            make.leading.equalTo(self.titleCategory.snp.trailing).offset(16)
            make.height.equalTo(40)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
            make.top.equalTo(self.titleCategory.snp.bottom).offset(16)
        }
    }
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if typeList == 0 {
            return self.listType.count
        } else {
            return self.listGenres.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchTypeItem = collectionView.dequeueReusableCell(indexPath: indexPath)
        if typeList == 0 {
            cell.aniGenreModel = self.listType[indexPath.row]
        } else {
            cell.aniGenreModel = self.listGenres[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if typeList == 0 {
            self.gotoDetailGenre(aniGenre: self.listType[indexPath.row])
        } else {
            self.gotoDetailGenre(aniGenre: self.listGenres[indexPath.row])
        }
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: kPadding, bottom: 0, right: kPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.size.width - 2 * kPadding
        var width2 = width/3-10
        if UIDevice.isIPad {
            width2 = width/5-18
        }
        return .init(width: width2, height: 40)
    }
}
