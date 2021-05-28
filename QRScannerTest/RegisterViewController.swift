//
//  RegisterViewController.swift
//  QRScannerTest
//
//  Created by IOS-Developer on 26.05.2021.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
    let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5300584435, green: 0.5018795133, blue: 0.5015630126, alpha: 1)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(moveTo), for: .touchUpInside)
        return button
    }()

    func displayWarningLabel(withText text: String) {
        errorLabel.text = text

        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.errorLabel.alpha = 1
        }) { [weak self] complete in
            self?.errorLabel.alpha = 0
        }
    }
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Vector"), for: .normal)
        button.addTarget(self, action: #selector(goToBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let passwordText: UITextField = {
        let password = UITextField()
        password.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        password.placeholder = "Пароль"
        return password
    }()

    let registLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = .systemFont(ofSize: 18)
        return label

    }()

    let emailText: UITextField = {
        let email = UITextField()
        email.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        email.placeholder = "Почта"
        email.keyboardType = .emailAddress
        return email
    }()
    let repeatPasswordText: UITextField = {
        let password = UITextField()
        password.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        password.placeholder = "Пароль"
        return password
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароли не совпадают"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)

        errorLabel.alpha = 0

        Auth.auth().addStateDidChangeListener({  (auth, user) in
            if user != nil {

            }
        })
    }

    @objc func moveTo() {
        guard let email = emailText.text, let password = passwordText.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in

            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                return
            }
            let tabBarVC = TabBarViewController()
            self.navigationController?.pushViewController(tabBarVC, animated: true)

        })
    }

    @objc func goToBack(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupConstraints() {
        view.addSubview(stackView)
        view.addSubview(backButton)
        view.addSubview(registLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        [registLabel, emailText, passwordText, repeatPasswordText, errorLabel, registerButton].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: 275)
        ])

        setTextFieldSize(for: emailText,passwordText,repeatPasswordText)
    }

    private func setTextFieldSize(for textFields: UITextField...) {
        textFields.forEach { (textField) in
            textField.widthAnchor.constraint(equalToConstant: 275).isActive = true
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }

}
