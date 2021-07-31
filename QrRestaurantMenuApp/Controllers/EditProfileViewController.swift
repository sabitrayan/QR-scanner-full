//
//  EditProfileViewController.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 30.06.2021.
//

import UIKit
import Firebase

protocol EditProfileViewControllerDelegate {
    func saveButtonTapped(name: String, surname: String, gender: String, date: String)
}

class EditProfileViewController: UIViewController {

    // MARK: -public properties
    var uid = "wTkLYYvYSYaH3DClKLxG"
    
    var profilePhoto: UIImage? {
        didSet {
            profileImageView.image = profilePhoto
        }
    }
    var phoneNumber: String? {
        didSet {
            phoneNumberLabel.text = phoneNumber
        }
    }
    var name: String? {
        didSet {
            nameTextField.text = name
        }
    }
    var surname: String? {
        didSet {
            surnameTextField.text = surname
        }
    }
    var gender: String? {
        didSet {
            genderTextField.text = gender
        }
    }
    
    var birthDate: String? {
        didSet {
            dateTextField.text = birthDate
        }
    }
    var delegate: EditProfileViewControllerDelegate?
    
    // MARK: -private properties
    
    private let genders = ["Мужчина" , "Женщина"]
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 11.5)
        label.text = "Номер телефона"
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "+7 (747) 190 77 50"
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        return label
    }()
    
    private let spaceView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont(name: "Inter-Medium", size: 17.5)
        textField.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Имя", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.542, green: 0.542, blue: 0.542, alpha: 1), NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 17.5) as Any])
        return textField
    }()
    
    private let spaceView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private let surnameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont(name: "Inter-Medium", size: 17.5)
        textField.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Фамилия", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.542, green: 0.542, blue: 0.542, alpha: 1), NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 17.5) as Any])
        return textField
    }()
    
    private let spaceView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private let datePicker = UIDatePicker()
    
    private let dateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont(name: "Inter-Medium", size: 17.5)
        textField.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Дата рождения", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.542, green: 0.542, blue: 0.542, alpha: 1), NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 17.5) as Any])
        return textField
    }()
    
    private let spaceView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    let pickerView = UIPickerView()
    
    private let genderTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont(name: "Inter-Medium", size: 17.5)
        textField.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Пол", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.542, green: 0.542, blue: 0.542, alpha: 1), NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 17.5) as Any])
        textField.textAlignment = .left
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        var button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        print(uid)
        button.setTitleColor(UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 17.5)
        button.backgroundColor = #colorLiteral(red: 0.7294117647, green: 1, blue: 0.9411764706, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        addDoneButtonOnKeyboard()
        createDatePicker()
        pickerView.delegate = self
        pickerView.dataSource = self
        dateTextField.delegate = self
        genderTextField.delegate = self
        nameTextField.delegate = self
        surnameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(popVC))
        let titleStackView = TabBarTitleView()
        titleStackView.title = "Редактировать профиль"
        tabBarController?.navigationItem.titleView = titleStackView
    }
    
    @objc func popVC(){
        navigationController?.popViewController(animated: false)
    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        toolbar.setItems([cancelBtn,spaceButton,doneBtn], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        genderTextField.inputView = pickerView
        genderTextField.textAlignment = .left
        
    }
    
    @objc func doneDatePressed(){
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed(){
        self.view.endEditing(true)
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        nameTextField.inputAccessoryView = doneToolbar
        surnameTextField.inputAccessoryView = doneToolbar
        dateTextField.inputAccessoryView = doneToolbar
        genderTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
    }
    
    @objc func saveButtonTapped(){
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.updateData(
            ["name" : nameTextField.text as Any,
             "surname" : surnameTextField.text as Any,
             "gender" : genderTextField.text as Any,
             "birthDate" : dateTextField.text as Any])

        guard let name = nameTextField.text else {return}
        guard let surname = surnameTextField.text else {return}
        guard let gender = genderTextField.text else {return}
        guard let date = dateTextField.text else {return}
        delegate?.saveButtonTapped(name: name, surname: surname, gender: gender, date: date)
        navigationController?.popViewController(animated: false)
    }
    
    func setupViews(){
        [profileImageView, phoneLabel, phoneNumberLabel, spaceView1, nameTextField, spaceView2, surnameTextField, spaceView3, dateTextField, spaceView4, genderTextField,saveButton].forEach{
            view.addSubview($0)
        }
    }
    
    func setupConstraints(){
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(100)
            make.top.equalToSuperview().inset(130)
        }
        phoneLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(phoneLabel.snp.bottom).offset(5)
        }
        spaceView1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(18)
        }
        nameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(75)
            make.top.equalTo(spaceView1.snp.bottom)
        }
        spaceView2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(nameTextField.snp.bottom)
        }
        surnameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(75)
            make.top.equalTo(spaceView2.snp.bottom)
        }
        spaceView3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(surnameTextField.snp.bottom)
        }
        dateTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(75)
            make.top.equalTo(spaceView3.snp.bottom)
        }
        spaceView4.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(dateTextField.snp.bottom)
        }
        genderTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(75)
            make.top.equalTo(spaceView4.snp.bottom)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(120)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
        genderTextField.resignFirstResponder()
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = nameTextField.text else {return}
        guard let surname = surnameTextField.text else {return}
        guard let gender = genderTextField.text else {return}
        guard let date = dateTextField.text else {return}
        if name.count > 0 && surname.count > 0 && gender.count > 0 && date.count > 0 {
            saveButton.isEnabled = true
            saveButton.alpha = 1
        }
    }
}
