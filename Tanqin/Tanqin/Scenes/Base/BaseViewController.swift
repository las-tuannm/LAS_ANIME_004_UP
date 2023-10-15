//
//  BaseViewController.swift
//  Tanqin
//
//  Created by HaKT on 27/09/2023.
//
import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

struct KeyboardData {
    let isShow: Bool
    let duration: TimeInterval
    let height: CGFloat
}

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    let keyboardTrigger = BehaviorRelay<KeyboardData>(value: KeyboardData(isShow: false, duration: 0, height: 0))
    private lazy var imagePicker = UIImagePickerController()
    let reachabilityManager = ReachabilityManager.shared
//    let isViewVisibleDriver = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("===> go to ", self.nibName  ?? " vaix of")
//        isViewVisibleDriver.accept(true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        isViewVisibleDriver.accept(false)

        dismissKeyboard()
    }
    
    deinit {
        print("<=== dismiss ", self.nibName ?? "Vai o")

    }
    
    func setImageFromImagePicker(image: UIImage) {}
    
    func actionCancelImagePicker() {}
    
    func openLibrary() {
        self.requestPermissionAccessPhotos { [weak self] isEnable in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if isEnable {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    self.showAlertOpenSettingPhotos()
                }
            }
        }
    }
    
    func trackShowToastError(_ viewModel: BaseViewModel) {
        viewModel.errorMsg.asDriverComplete().drive(onNext: { message in
            Toast.show(message)
        }).disposed(by: disposeBag)
    }
    
//    func enableButton(_ buttonTap: UIButton?, _ viewBorder: UIView?, isEnable: Bool) {
//        viewBorder?.backgroundColor = isEnable ? Constants.Color.appPrimaryColor : Constants.Color.btnDisableColor
//        buttonTap?.isEnabled = isEnable
//    }
    
    func addFirstResponsder(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func addGestureDismissKeyboard(view: UIView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

//MARK: keyboard Notification
extension BaseViewController {
    private func addKeyboardHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func removeKeyboardHandler() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func keyboardWillChangeFrame(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self]
            (keyboardFrame, duration) in
            guard let self = self else {
                return
            }
            let keyboardHeight = self.view.bounds.height - keyboardFrame.origin.y
            print(keyboardHeight)
            let isShow = keyboardFrame.height > 0 ? true : false
            self.keyboardTrigger.accept(KeyboardData(isShow: isShow, duration: duration, height: keyboardHeight))
        }
    }
    
    private func animateWithKeyboard(
        notification: NSNotification,
        animations: ((_ keyboardFrame: CGRect, _ duration: TimeInterval) -> Void)?
    ) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!
        
        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue, duration)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        // Start the animation
        animator.startAnimation()
    }
}

//MARK: library
extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let image = img else {
            return
        }
        setImageFromImagePicker(image: image)

        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        actionCancelImagePicker()
    }
}

//MARK: Navigation
extension BaseViewController {
    func push(_ vc: UIViewController, animation: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animation)
    }
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func setRoot(_ vc: UIViewController) {
        self.navigationController?.viewControllers  = [vc]
    }
}

