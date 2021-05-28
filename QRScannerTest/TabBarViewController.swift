//
//  TabBarViewController.swift
//  QRScannerTest
//
//  Created by ryan on 5/26/21.
//

import UIKit

class TabBarViewController: UITabBarController {
//    let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.spacing = 10
//        return stackView
//    }()
//
//    let restButton: UIButton = {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(moveToRest), for: .touchUpInside)
//        return button
//    }()
//    let profileButton: UIButton = {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
//        return button
//    }()
//    let qrButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "qr-code"), for: .normal)
//        button.addTarget(self, action: #selector(moveToQR), for: .touchUpInside)
//        return button
//    }()
//
//    @objc func moveToQR() {
//        let restVC = RestaurantsViewController()
//        navigationController?.popToViewController(restVC, animated: true)
//    }
//
//    @objc func moveToProfile() {
//        let profileVC = ProfileViewController()
//        navigationController?.popToViewController(profileVC, animated: true)
//    }
//
//    @objc func moveToRest() {
//        let qrVC = QRViewController()
//        navigationController?.popToViewController(qrVC, animated: true)
//    }

    private func setupTabBar() {
        tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        tabBar.layer.cornerRadius = 15
        tabBar.layer.shadowRadius = 10
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true

        let restVC = UINavigationController(rootViewController:RestaurantsViewController())
            restVC.tabBarItem.image = UIImage(named: "restourants")
            //restVC.tabBarItem.selectedImage = UIImage(named: "restaurants")
            navigationController?.popToViewController(restVC, animated: true)

        let profileVC = UINavigationController(rootViewController:ProfileViewController())
            profileVC.tabBarItem.image = UIImage(named: "Person")
            //profileVC.tabBarItem.selectedImage = UIImage(named: "Person")
            navigationController?.popToViewController(profileVC, animated: true)

        let qrVC = UINavigationController(rootViewController:QRViewController())
            qrVC.tabBarItem.image = UIImage(named: "qr-code")
            navigationController?.popToViewController(qrVC, animated: true)

        viewControllers = [restVC, profileVC, qrVC]

        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }

    }
//        view.addSubview(viewControllers)
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//
//        ])
//        [restButton, profileButton, qrButton].forEach { stackView.addArrangedSubview($0) }
//    }

    
    let errorMessage: UILabel = {
        let label = UILabel()
        label.text = "Ошибка при сканировании, попробуйте еще раз"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupTabBar()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
    }

    func setupConstraints() {
        view.addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

        ])
    }
}
