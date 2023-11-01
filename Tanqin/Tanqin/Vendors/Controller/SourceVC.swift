import UIKit
import SnapKit
import Countly

class SourceVC: BaseController {

    fileprivate let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate let backButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "ic-back"), for: .normal)
        return view
    }()
    
    fileprivate let headerTitle: UILabel = {
        let view = UILabel()
        view.font = UIFont.bold(of: 24)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.text = "Soucre"
        return view
    }()
    
    fileprivate let viewAniware: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        view.layer.borderColor = UIColor(rgb: 0x932EFF).cgColor
        return view
    }()
    
    fileprivate let imgSelectAniware: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_select_source"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let imgAniware: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_aniwave"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let lbLinkAniWare: UILabel = {
        let view = UILabel()
        view.font = UIFont.regular(of: 12)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.text = SourceAnime.aniware.getLinkSource()
        return view
    }()
    
    fileprivate let view9Anime: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        view.layer.borderColor = UIColor(rgb: 0x932EFF).cgColor
        return view
    }()
    
    fileprivate let imgSelect9Ani: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_select_source"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let img9Anime: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_9anime"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let lbLink9Anime: UILabel = {
        let view = UILabel()
        view.font = UIFont.regular(of: 12)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.text = SourceAnime.anime9.getLinkSource()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        viewAniware.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectAniware)))
        view9Anime.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(select9Ani)))
        setViewSelectSource()
    }
    
    func initView(){
        self.view.addSubview(viewContent)
        viewContent.layoutSafeAreaEdges()
        self.viewContent.addSubview(backButton)
        self.viewContent.addSubview(headerTitle)
        self.viewContent.addSubview(viewAniware)
        self.viewContent.addSubview(view9Anime)
        
        self.viewAniware.addSubview(imgSelectAniware)
        self.viewAniware.addSubview(imgAniware)
        self.viewAniware.addSubview(lbLinkAniWare)
        
        self.view9Anime.addSubview(imgSelect9Ani)
        self.view9Anime.addSubview(img9Anime)
        self.view9Anime.addSubview(lbLink9Anime)
        
        self.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        self.headerTitle.snp.makeConstraints { make in
            make.leading.equalTo(self.backButton.snp.trailing)
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.viewAniware.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.headerTitle.snp.bottom).offset(12)
            make.height.equalTo(67)
        }
        
        self.imgSelectAniware.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.height.width.equalTo(16)
        }
        
        self.imgAniware.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(14)
            make.height.equalTo(20)
            make.width.equalTo(67)
        }
        
        self.lbLinkAniWare.snp.makeConstraints { make in
            make.top.equalTo(self.imgAniware.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
        }
        
        self.view9Anime.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.viewAniware.snp.bottom).offset(16)
            make.height.equalTo(67)
        }
        
        self.imgSelect9Ani.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.height.width.equalTo(16)
        }
        
        self.img9Anime.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(20)
            make.width.equalTo(69)
        }
        
        self.lbLink9Anime.snp.makeConstraints { make in
            make.top.equalTo(self.img9Anime.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    @objc func selectAniware() {
        HTMLService.shared.setSourceAnime(sourceAnime: .aniware)
        self.setViewSelectSource()
        let event = ["source" :  HTMLService.shared.getSourceAnime().getTitleSource()]
        Countly.sharedInstance().recordEvent("source", segmentation:event)
    }
    
    @objc func select9Ani() {
        HTMLService.shared.setSourceAnime(sourceAnime: .anime9)
        self.setViewSelectSource()
        let event = ["source" :  HTMLService.shared.getSourceAnime().getTitleSource()]
        Countly.sharedInstance().recordEvent("source", segmentation:event)
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }

    func setViewSelectSource(){
        if HTMLService.shared.getSourceAnime() == .aniware {
            viewAniware.layer.borderColor = UIColor.init(rgb: 0x932EFF).cgColor
            view9Anime.layer.borderColor = UIColor.init(rgb: 0xF4F4F4).withAlphaComponent(0.17).cgColor
            imgSelectAniware.isHidden = false
            imgSelect9Ani.isHidden = true
        } else {
            viewAniware.layer.borderColor = UIColor.init(rgb: 0xF4F4F4).withAlphaComponent(0.17).cgColor
            view9Anime.layer.borderColor = UIColor.init(rgb: 0x932EFF).cgColor
            imgSelectAniware.isHidden = true
            imgSelect9Ani.isHidden = false
        }
    }
}
