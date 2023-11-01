import UIKit
import SnapKit
import StoreKit
import Countly

enum SettingLayout {
    case source, rating, policy, share, feedback, text_color, text_size, position
    
    func getTitle() -> String {
        switch self {
        case .source:
            return "Soucre"
        case .rating:
            return "Rate app"
        case .policy:
            return "Term and policy"
        case .share:
            return "Share app to friend"
        case .feedback:
            return "Feedback"
        case .text_color:
            return "Subtitle text color"
        case .text_size:
            return "Subtitle text size"
        case .position:
            return "Subtitle padding at the bottom"
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .source:
            return UIImage(named: "ic_setting_source")
        case .rating:
            return UIImage(named: "ic_setting_rate")
        case .policy:
            return UIImage(named: "ic_setting_policy")
        case .share:
            return UIImage(named: "ic_setting_share")
        case .feedback:
            return UIImage(named: "ic_setting_feedback")
        case .text_color:
            return nil
        case .text_size:
            return nil
        case .position:
            return nil
        }
    }
    
}

class SettingVC: BaseController {
    
    fileprivate let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate let headerTitle: UILabel = {
        let view = UILabel()
        view.font = UIFont.bold(of: 24)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.text = "Setting"
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
        view.registerItem(cell: SettingCell.self)
        view.registerItem(cell: SettingColorCell.self)
        view.registerItem(cell: SettingFontCell.self)
        return view
    }()
    
    fileprivate let layouts: [SettingLayout] = [.text_color, .text_size, .position, .rating, .policy, .share, .feedback]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func initView(){
        self.view.addSubview(viewContent)
        self.viewContent.layoutSafeAreaEdges()
        self.viewContent.addSubview(headerTitle)
        self.viewContent.addSubview(collectionView)
        
        self.headerTitle.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(self.headerTitle.snp.bottom).offset(16)
        }
        
    }
}

extension SettingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (layouts[indexPath.row] == .text_color) {
            let cell: SettingColorCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.typeLayout = layouts[indexPath.row]
            return cell
        } else if (layouts[indexPath.row] == .text_size) {
            let cell: SettingFontCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.typeLayout = layouts[indexPath.row]
            return cell
        } else if (layouts[indexPath.row] == .position) {
            let cell: SettingFontCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.typeLayout = layouts[indexPath.row]
            return cell
        } else {
            let cell: SettingCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.typeLayout = layouts[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectAction(typeLayout: layouts[indexPath.row])
    }
    
    func selectAction(typeLayout: SettingLayout) {
        switch typeLayout {
        case .source:
            changeSource()
            break
        case .rating:
            rating()
            break
        case .policy:
            policy()
            break
        case .share:
            share()
            break
        case .feedback:
            feedback()
            break
        default:
            break
        }
    }
    
    func changeSource(){
        self.navigationController?.pushViewController(SourceVC(), animated: true)
    }
    
    func rating(){
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                DispatchQueue.main.async {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    func policy(){
        let urlStr = AppInfo.privacy
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
            
        }
    }
    
    func share(){
        guard let url = URL(string: "https://apps.apple.com/us/app/id\(AppInfo.id)") else { return }
        let objectsToShare: [Any] = ["", url]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func moreapp(){
        let urlStr = AppInfo.moreapp
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
            
        }
    }
    
    func feedback() {
        if UserDefaults.standard.integer(forKey: "countly-feedback") > 0 {
            Countly.sharedInstance().presentRatingWidget(withID: AppInfo.widgetID) { error in }
        }
        else {
            EmailController().compose(controller: self)
        }
    }
}

extension SettingVC: UICollectionViewDelegateFlowLayout {
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
        if (layouts[indexPath.row] == .text_color) {
            return .init(width: width, height: 72)
        } else {
            return .init(width: width, height: 48)
        }
    }
}



import MessageUI

class EmailController: NSObject, MFMailComposeViewControllerDelegate {
    func compose(controller: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([AppInfo.email])
            
            controller.present(composeVC, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Notification", message: "You haven't set up an email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            if let popover = alert.popoverPresentationController {
                popover.sourceView = controller.view
                popover.sourceRect = controller.view.bounds
            }
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
