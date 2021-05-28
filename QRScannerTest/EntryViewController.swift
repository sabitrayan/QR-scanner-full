import UIKit
import FirebaseAuth

class EntryViewController: UIViewController {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let errorMessage: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()

    func displayWarningLabel(withText text: String) {
        errorMessage.text = text

        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.errorMessage.alpha = 1
        }) { [weak self] complete in
            self?.errorMessage.alpha = 0
        }
    }

    let passwordText: UITextField = {
        let password = UITextField()
        password.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        password.placeholder = "Пароль"
        return password
    }()
    
    let emailText: UITextField = {
        let email = UITextField()
        email.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        email.placeholder = "Почта"
        email.keyboardType = .emailAddress
        return email
    }()
    
    let entryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5300584435, green: 0.5018795133, blue: 0.5015630126, alpha: 1)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(moveTo), for: .touchUpInside)
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.690831542, green: 0.6626741886, blue: 0.6623317599, alpha: 1)
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(moveToRegister), for: .touchUpInside)
        return button
    }()
    
    let forgorPasswordButton: UIButton = {
        let forgot = UIButton()
        forgot.setTitle("Забыли пароль?", for: .normal)
        forgot.titleLabel?.font = .systemFont(ofSize: 12)
        forgot.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return forgot
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        setupConstraints()
        navigationController?.navigationBar.isHidden = true
    }
    

    @objc func moveTo() {
        guard let email = emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines), email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }


        print(email,password)
        Auth.auth().signIn(withEmail: password, password: email, completion: { [weak self] (user, error) in
            
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            if user != nil {
                let tabBarVC = TabBarViewController()
                self?.navigationController?.pushViewController(tabBarVC, animated: true)
                return
            }

            self?.displayWarningLabel(withText: "No such user")
        })

    }


    
    @objc func moveToRegister() {
        let regVC = RegisterViewController()
        navigationController?.pushViewController(regVC, animated: true)
    }
    
    
    func setupConstraints() {
        view.addSubview(logoImage)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 122),
            logoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -122),
            logoImage.heightAnchor.constraint(equalToConstant: 130),
            logoImage.widthAnchor.constraint(equalToConstant: 130)
        ])


        [errorMessage, passwordText, emailText, entryButton, registerButton, forgorPasswordButton].forEach { stackView.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        setSize(for: registerButton, entryButton)
        setTextFieldSize(for: passwordText, emailText)
    }
    
    private func setSize(for buttons: UIButton...) {
        buttons.forEach { (button) in
            button.widthAnchor.constraint(equalToConstant: 275).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    private func setTextFieldSize(for textFields: UITextField...) {
        textFields.forEach { (textField) in
            textField.widthAnchor.constraint(equalToConstant: 275).isActive = true
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }


}

