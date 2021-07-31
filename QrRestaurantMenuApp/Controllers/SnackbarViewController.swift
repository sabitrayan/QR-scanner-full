//
//  SnackbarViewController.swift
//  QRRestarantMenuApp
//
//  Created by ryan on 6/12/21.
//
import Foundation
import UIKit
import SnapKit
import FlagPhoneNumber
import FirebaseAuth
import Firebase
import FloatingPanel
import UIKit

class SnackbarViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var phoneNumber: String?
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var verId = ""
    var listController: FPNCountryListViewController!
    var floatingPanel = FloatingPanelController()
    var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private var textLabel: UILabel = {
        var label = UILabel()
        label.text = "Войти в аккаунт"
        label.textColor = .black
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 21.88)
        label.textColor = #colorLiteral(red: 0.07058823529, green: 0.2, blue: 0.2980392157, alpha: 1)
        label.font = label.font.withSize(20)
        return label
    }()

    private let phoneTextField: FPNTextField = {
        var textField = FPNTextField()
        textField.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Номер телефона", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.displayMode = .list
        return textField
    }()

    private var sendButton: UIButton = {
        var button = UIButton()
        button.setTitle("Отправить код", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7294117647, green: 1, blue: 0.9411764706, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 0.07058823529, green: 0.2, blue: 0.2980392157, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 21)
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 1
        return button
    }()

    @objc private func sendButtonAction() {
        guard phoneNumber != nil else {return}
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { verificationId, error in

            if error != nil {
                print(error?.localizedDescription ?? "is empty")
            }else {
                self.transitionToVerificationView(verificationId: verificationId)
            }
        }
    }

    private func transitionToVerificationView(verificationId: String?) {
        self.floatingPanel.dismiss(animated: false)
        let child = PhoneVerificationViewController()
        child.verificationId = verificationId
        floatingPanel.addPanel(toParent: self, at: 3, animated: true) {
            self.floatingPanel.set(contentViewController: child)
        }
    }
    lazy private var closeButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "CloseButton.png") {
            button.setImage(image, for: .normal)
        }
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return button
    }()

    @objc private func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        floatingPanel.delegate = self
        floatingPanel.contentMode = .fitToBounds

        setupConfig()
        setupConstraints()
    }
    private func setupConfig() {
        phoneTextField.delegate = self
        listController = FPNCountryListViewController(style: .grouped)
        listController?.setup(repository: phoneTextField.countryRepository)
        listController.didSelect = {
            country in self.phoneTextField.setFlag(countryCode: country.code)
        }
    }

    func setupConstraints(){

//        view.addSubview(stackView)

//        stackView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(20)
//            make.top.equalToSuperview().inset(20)
//            make.height.equalTo(50)
//        }
//        [textLabel, phoneTextField, sendButton].forEach{
//            stackView.addArrangedSubview($0)
//        }
        view.addSubview(textLabel)
        view.addSubview(phoneTextField)
        view.addSubview(sendButton)
        view.addSubview(closeButton)

        closeButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(25)
            $0.width.equalTo(25)
        }

        textLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            //make.centerX.equalToSuperview()
        }

        phoneTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(textLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
        }

        sendButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
}

extension SnackbarViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {

    }

    func fpnDisplayCountryList() {
        let navigationController = UINavigationController(rootViewController: listController)
        listController.title = "Countries"
        phoneTextField.text = ""
        self.present(navigationController, animated: true)
    }

    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            sendButton.alpha = 1
            sendButton.isEnabled = true
            phoneNumber = textField.getFormattedPhoneNumber(format: .International)
        }else{
            sendButton.alpha = 0.5
            sendButton.isEnabled = false
        }
    }
}
extension SnackbarViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return MyFloatingPanelLayout()
    }

    func floatingPanel(_ fpc: FloatingPanelController, layoutFor size: CGSize) -> FloatingPanelLayout {
        return MyFloatingPanelLayout()
    }
}
