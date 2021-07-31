//
//  AddCardViewController.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 10.06.2021.
//

import UIKit
import SnapKit
import FirebaseFirestore

class AddCardViewController: UIViewController {
    
    let monthValid = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    
    private let pickerView = UIPickerView()
    private let datePicker = UIDatePicker()
    private let toolBar = UIToolbar()
    var saveCard: (() -> Void)?
    private let db = Firestore.firestore()
    var newCards: [String: Any]?
    var cards: [Card]? = []
    
    private let addCardLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить карту"
        label.textAlignment = .left
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "remove"), for: .normal)
        button.addTarget(self, action: #selector(tapDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.7294117647, green: 1, blue: 0.9411764706, alpha: 1)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        return button
    }()
    
    private let allElements: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private let dateAndCvv: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    private let numCard: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8195181489, green: 0.8196596503, blue: 0.8195091486, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let nameCard: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8195181489, green: 0.8196596503, blue: 0.8195091486, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let validDateCard: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8195181489, green: 0.8196596503, blue: 0.8195091486, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let cvvView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8195181489, green: 0.8196596503, blue: 0.8195091486, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let numberCard: CardTextField = {
        let textField = CardTextField(placeholderText: "Номер карты", keyboard: .decimalPad)
        return textField
    }()

    private let errorNumCard: UILabel = {
        let label = UILabel()
        label.text = "Неверный номер карты"
        label.textColor = .red
        label.font = .systemFont(ofSize: 11.5)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    private let holderName: CardTextField = {
        let textField = CardTextField(placeholderText: "Имя Фамилия", keyboard: .default)
        textField.autocapitalizationType = .allCharacters
        return textField
    }()
    
    private let validMonth: CardTextField = {
        let textField = CardTextField(placeholderText: "ММ", keyboard: .decimalPad)
        textField.textAlignment = .center
        return textField
    }()
    
    private let slashIcon: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.5411153436, green: 0.5412116647, blue: 0.5411092043, alpha: 1)
        return label
    }()
    
    private let validYear: CardTextField = {
        let textField = CardTextField(placeholderText: "ГГ", keyboard: .decimalPad)
        textField.textAlignment = .center
        return textField
    }()
    
    private let errorValidCVV: UILabel = {
        let label = UILabel()
        label.text = "Некорректный CVV код"
        label.font = .systemFont(ofSize: 11.5)
        label.textColor = .red
        label.isHidden = true
        label.textAlignment = .left
        return label
    }()
    
    private let cvvCode: CardTextField = {
        let textField = CardTextField(placeholderText: "CVV", keyboard: .numberPad)
        textField.isSecureTextEntry = true
        return textField
    }()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addElements()
        setupConstraints()
        addTextFieldDelegate()
        configureToolBar()
        dateField()
        configurePicker()
        registerForKeyboardNC()
        addDoneButtonOnKeyboard()
        pickerView.delegate = self
        pickerView.dataSource = self
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        QRFirebaseDatabase.shared.getCardsOfUser(uid: uid) { [weak self] cards in
            self?.newCards = cards
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    private func configureToolBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        toolBar.sizeToFit()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        numberCard.inputAccessoryView = doneToolbar
        holderName.inputAccessoryView = doneToolbar
        validMonth.inputAccessoryView = doneToolbar
        validYear.inputAccessoryView = doneToolbar
        cvvCode.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        numberCard.resignFirstResponder()
        holderName.resignFirstResponder()
        validMonth.resignFirstResponder()
        validYear.resignFirstResponder()
        cvvCode.resignFirstResponder()
    }
    
    private func dateField() {
        validMonth.inputAccessoryView = toolBar
        validYear.inputAccessoryView = toolBar
    }
    private func addTextFieldDelegate() {
        numberCard.delegate = self
        holderName.delegate = self
        validMonth.delegate = self
        validYear.delegate = self
        cvvCode.delegate = self
    }
    private func addElements() {
        view.addSubview(addCardLabel)
        view.addSubview(cancelButton)
        view.addSubview(addButton)
        view.addSubview(allElements)
        view.addSubview(errorValidCVV)
        cvvView.addSubview(cvvCode)
        numCard.addSubview(numberCard)
        nameCard.addSubview(holderName)
        [validMonth, slashIcon, validYear].forEach { validDateCard.addSubview($0) }
        [numCard, errorNumCard, nameCard, dateAndCvv].forEach { allElements.addArrangedSubview($0) }
        [validDateCard, cvvView].forEach { dateAndCvv.addArrangedSubview($0) }
    }
    
    private func configurePicker() {
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 12, to: Date())
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        validYear.inputView = datePicker
        validMonth.inputView = pickerView
        datePicker.addTarget(self, action: #selector(pressedDone), for: .valueChanged)
    }
    
    private func setupConstraints() {
        addCardLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.left.equalToSuperview().inset(20)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(37.75)
            $0.trailing.equalToSuperview().inset(27.75)
        }
        allElements.snp.makeConstraints {
            $0.top.equalTo(addCardLabel.snp.bottom).offset(49)
            $0.left.right.equalToSuperview().inset(20)
        }
        numberCard.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(20)
        }
        holderName.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(20)
        }
        validMonth.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalToSuperview().offset(20)
        }
        slashIcon.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalTo(validMonth.snp.right).offset(1)
            $0.height.width.equalTo(17)
            
        }
        validYear.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalTo(slashIcon.snp.right).offset(1)
        }
        errorValidCVV.snp.makeConstraints {
            $0.top.equalTo(cvvView.snp.bottom).offset(8)
            $0.right.equalToSuperview().inset(70)
        }
        cvvCode.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(20)
        }
        addButton.snp.makeConstraints {
            $0.top.equalTo(dateAndCvv.snp.bottom).offset(10)
            $0.right.left.equalToSuperview().inset(20)
            $0.height.equalTo(53)
        }
    }
  
    @objc private func tapDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func done() {
        view.endEditing(true)
    }
    
    @objc private func pressedDone() {
        getDateFormmater()
        view.endEditing(true)
    }
    private func getDateFormmater() {
        let formmater = DateFormatter()
        formmater.dateFormat = "yy"
        validYear.text = formmater.string(from: datePicker.date)
    }
    private func registerForKeyboardNC() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   let uid = "wTkLYYvYSYaH3DClKLxG"
    
    private func parseDataCard(uid: String) {
        
        let key = "card\(newCards?.count ?? 0 + 1)"
        let value = ["cvv" : cvvCode.text, "holderName" : holderName.text, "numberCard" : numberCard.text, "validMonth" : validMonth.text, "validYear": validYear.text]
        
        newCards?[key] = value
        
    }
    
    @objc private func addCard() {
        let document = db.collection("users").document(uid)
        parseDataCard(uid: uid)
        document.updateData(["cards": newCards ?? 0
        ])
        saveCard?()
        dismiss(animated: true, completion: nil)
    }
}
extension AddCardViewController: UITextFieldDelegate {
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String

        if numberCard == textField {
            textField.text = lastText.format("nnnn nnnn nnnn nnnn", oldString: text)
            guard let numberCard = numberCard.text?.count else { return false }
            if numberCard < 19 {
                errorNumCard.isHidden = false
                numCard.layer.borderWidth = 1
                numCard.layer.borderColor = UIColor.red.cgColor
            } else {
                errorNumCard.isHidden = true
                numCard.layer.borderWidth = 1
                numCard.layer.borderColor = UIColor.lightGray.cgColor
            }
            return false
        } else if validYear == textField {
            textField.text = lastText.format("nn", oldString: text)
            return false
        } else if cvvCode == textField {
            textField.text = lastText.format("NNN", oldString: text)
            guard let codeCVV = cvvCode.text else { return false }
            if codeCVV.count < 3  {
                cvvView.layer.borderWidth = 1
                cvvView.layer.borderColor = UIColor.red.cgColor
                errorValidCVV.isHidden = false
                addButton.isEnabled = false
                addButton.alpha = 0.5
            } else {
                cvvView.layer.borderWidth = 1
                errorValidCVV.isHidden = true
                cvvView.layer.borderColor = UIColor.lightGray.cgColor
                addButton.isEnabled = true
                addButton.alpha = 1
            }
            return false
        } else if validMonth == textField {
            textField.text = lastText.format("NN", oldString: text)
            return false
        }

        return true
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {
        view.frame.origin.y = -300
        
    }
   
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0.0
    }
}
extension AddCardViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monthValid.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return monthValid[row]
    }
}
extension AddCardViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        validMonth.text = monthValid[row]
        validMonth.resignFirstResponder()
    }
}
