//
//  PhoneVerificationViewController.swift
//  QrRestaurantMenuApp
//
//  Created by ryan on 7/1/21.
//

import UIKit
import FirebaseAuth
import SnapKit
import FloatingPanel

class PhoneVerificationViewController: UIViewController, UITextFieldDelegate {

   private lazy var textField: UITextField = {
       let textField = UITextField()
       textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
       textField.tintColor = .clear
       textField.textColor = .clear
       textField.keyboardType = .numberPad
       textField.textContentType = .oneTimeCode
       textField.backgroundColor = .clear
       textField.isOpaque = true
       return textField
   }()

    var floatingPanel = FloatingPanelController()
   var phoneNumber: String?

   var verificationId: String?

   var didEnterLastDigit: ((String) -> Void)?

  
   private var digitLabels = [UILabel]()

   var count = 60

   var resendTimer = Timer()

   var stackView: UIStackView = {
       var stackView = UIStackView()
       stackView.axis = .vertical
       stackView.spacing = 10
       return stackView
   }()

    private var enterLabel: UILabel = {
        var label = UILabel()
        label.text = "Войти в аккаунт"
        label.textColor = .black
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 21.88)
        label.textColor = #colorLiteral(red: 0.07058823529, green: 0.2, blue: 0.2980392157, alpha: 1)
        label.font = label.font.withSize(20)
        return label
    }()

    var textLabel: UILabel = {
        var label = UILabel()
        label.text = "Введите код из СМС"
        label.font = UIFont(name: "Inter-Medium", size: 11.5)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

   private lazy var tapRecognizer: UITapGestureRecognizer = {
       let recognizer = UITapGestureRecognizer()
       recognizer.addTarget(self, action: #selector(becomeFirstResponder))
       //print(textField.text)
       return recognizer
   }()



   @objc private func textDidChange() {

       guard let text = textField.text, text.count <= digitLabels.count else { return }

       for i in 0 ..< digitLabels.count {
           let currentLabel = digitLabels[i]

           if i < text.count {
               let index = text.index(text.startIndex, offsetBy: i)
               currentLabel.text = String(text[index])
           } else {
               currentLabel.text = "_"
           }
       }

       if text.count == digitLabels.count {
           didEnterLastDigit?(text)
       }
   }


   private func createLabelsStackView() -> UIStackView {
       let stackView = UIStackView()
       stackView.translatesAutoresizingMaskIntoConstraints = false
       stackView.axis = .horizontal
       stackView.alignment = .fill
       stackView.distribution = .fillEqually
       stackView.spacing = 10

       for _ in 1 ... 6 {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textAlignment = .center
           label.font = .systemFont(ofSize: 40)
           label.isUserInteractionEnabled = true
           label.text = "_"
           label.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
            label.layer.cornerRadius = 10
           stackView.addArrangedSubview(label)

           digitLabels.append(label)
       }

       return stackView
   }

   lazy var sendButton: UIButton = {
       let button = UIButton()
       button.setTitle("Подтвердить", for: .normal)
       button.backgroundColor = #colorLiteral(red: 0.7294117647, green: 1, blue: 0.9411764706, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 0.07058823529, green: 0.2, blue: 0.2980392157, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 17.5)

       button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
       button.isEnabled = true
       return button
   }()

   lazy var changeNumber: UIButton = {
       let button = UIButton()
       button.setTitle("Изменить номер", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1019607843, green: 0.6666666667, blue: 0.5450980392, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 11.5)

       button.addTarget(self, action: #selector(changeNumberAction), for: .touchUpInside)
       button.isEnabled = true
       return button
   }()


   lazy var resendCode: UIButton = {
       let button = UIButton()
       button.isHidden = true
       button.setTitle("Отправить код еще раз", for: .normal)
       button.setTitleColor(#colorLiteral(red: 0.1019607843, green: 0.6666666667, blue: 0.5450980392, alpha: 1), for: .normal)
    button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 11.5)

       button.addTarget(self, action: #selector(resendCodeAction), for: .touchUpInside)
       button.isEnabled = true
       return button
   }()

   @objc func resendCodeAction(){
       //weak var phoneNumber = LoginViewController().phoneNumber

       PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { verificationId, error in
           if error != nil {
               print(error?.localizedDescription ?? "is empty")
           }else {
                let child = PhoneVerificationViewController()
                self.floatingPanel.dismiss(animated: false)
                self.floatingPanel.addPanel(toParent: self, at: 3, animated: true) {
                    self.floatingPanel.set(contentViewController: child)
                }
           }
       }
   }

    lazy var timer: UIButton = {
        let button = UIButton()
       button.setTitleColor(#colorLiteral(red: 0.3529411765, green: 0.3803921569, blue: 0.4039215686, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 11.5)

        resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        button.isEnabled = true
        return button
    }()


   @objc func update() {
       if(count > 0) {
           count = count - 1
           timer.setTitle("Отправка следующего кода через: \(count)", for: .normal)

       }
       else {
           resendTimer.invalidate()
           timer.isHidden = true
           resendCode.isHidden = false
           // if you want to reset the time make count = 60 and resendTime.fire()
       }
   }

    @objc func changeNumberAction(){
        let child = SnackbarViewController()
        self.dismiss(animated: true, completion: nil)
        floatingPanel.addPanel(toParent: self, at: 4, animated: true){
            self.floatingPanel.set(contentViewController: child)
        }
    }

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textField.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        textField.resignFirstResponder()
    }
    
   override func viewDidLoad() {
       super.viewDidLoad()
        textField.delegate = self
        setupConstraints()
    self.addDoneButtonOnKeyboard()

        floatingPanel.delegate = self
        floatingPanel.contentMode = .fitToBounds


       // Do any additional setup after loading the view.
   }

   @objc func sendButtonAction(){
        guard let code = textField.text else {return}
        print(code)
        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: verificationId!,verificationCode: code)
       Auth.auth().signIn(with: credetional) { (_, error) in
           if error != nil {
               let ac = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle:.alert)
               let cancel = UIAlertAction(title: "Cancel", style: .cancel)

               ac.addAction(cancel)
               self.present(ac, animated: true)
           } else {
               self.transitionToQR()

           }
       }
   }

   func transitionToQR(){
        let tc = MainTabBar()
        tc.selectedIndex = 2
   }

   func setupConstraints(){
       view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       let labelsStackView = createLabelsStackView()

       view.addSubview(textLabel)
       view.addSubview(sendButton)
       view.addSubview(changeNumber)
       view.addSubview(labelsStackView)
       view.addSubview(textField)
       view.addSubview(timer)
       view.addSubview(resendCode)
       view.addSubview(enterLabel)
    
        enterLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(enterLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(14)
        }

        labelsStackView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(47)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(47)
        }
        timer.snp.makeConstraints{ make in
            make.top.equalTo(labelsStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(14)
        }

        resendCode.snp.makeConstraints{ make in
            make.top.equalTo(labelsStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(14)
        }

        changeNumber.snp.makeConstraints{ make in
            make.top.equalTo(timer.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(14)
        }

        sendButton.snp.makeConstraints { make in
            make.top.equalTo(changeNumber.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
   }
}

extension PhoneVerificationViewController: UITextViewDelegate {
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       guard let characterCount = textField.text?.count else { return false }
       return characterCount < digitLabels.count || string == ""
   }
   func textFieldDidChangeSelection(_ textField: UITextField) {
       if textField.text?.count == 6 {
           sendButton.isEnabled = true
           sendButton.alpha = 1
       }
       else {
           sendButton.isEnabled = false
           sendButton.alpha = 0.5
       }
   }
}

extension PhoneVerificationViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor size: CGSize) -> FloatingPanelLayout {
        return MyFloatingPanelLayout()
    }

    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return MyFloatingPanelLayout()
    }
}
