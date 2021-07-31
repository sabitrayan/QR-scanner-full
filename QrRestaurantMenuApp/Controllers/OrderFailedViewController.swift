//
//  OrderFailedViewController.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 17.06.2021.
//

import UIKit
import FloatingPanel

class OrderFailedViewController: UIViewController {
    
    private let floationgPanel = FloatingPanelController()
    
    private let errorIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "error")
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Не удалось оплатить заказ"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let tryOnceMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Попробуйте еще раз"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var tryOnceMoreButton: UIButton = {
        var button = UIButton()
        button.setTitle("Попробовать снова", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(tryOnceMore), for: .touchUpInside)
        return button
    }()
    
    private lazy var changePaymentButton: UIButton = {
        var button = UIButton()
        button.setTitle("Другой способ оплаты", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(changedPayment), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelOrderButton: UIButton = {
        var button = UIButton()
        button.setTitle("Отменить заказ", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(cancelOrder), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        setupViews()
        setupConstraints()
    }
    
    @objc private func changedPayment() {
        let vc = SelectCardViewController()
        floationgPanel.addPanel(toParent: self, at: 3, animated: true) {
            self.floationgPanel.set(contentViewController: vc)
        }
    }
    
    @objc private func tryOnceMore() {
        
    }
    
    @objc private func cancelOrder() {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите \nотменить заказ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self]  action in
            let alert = UIAlertController(title: "", message: "Ваш заказ отменен", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "На главную", style: .default, handler: { [weak self] action in
                let menuVC = MenuViewController()
                self?.navigationController?.pushViewController(menuVC, animated: true)
                self?.navigationController?.navigationBar.isHidden = true
            }))
            self?.present(alert, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupViews(){
        view.addSubview(errorIcon)
        
        [errorLabel, tryOnceMoreLabel, buttonStackView].forEach {
            view.addSubview($0)
        }
        [tryOnceMoreButton, changePaymentButton, cancelOrderButton].forEach{
            buttonStackView.addArrangedSubview($0)
        }
        
    }
    
    private func setupConstraints(){
        errorIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37.31)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(57.38)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(250)
            make.centerX.equalToSuperview()
        }
        tryOnceMoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(errorLabel.snp.bottom).offset(10)
        }
        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(tryOnceMoreLabel.snp.bottom).offset(75)
        }
        tryOnceMoreButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        changePaymentButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        cancelOrderButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
    }
    
}
