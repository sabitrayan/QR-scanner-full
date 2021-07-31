//
//  MainPageViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 30.05.2021.
//

import UIKit
import SnapKit
import Firebase

class MainTabBar: UITabBarController {

    let bezierTabBar = TabBar()
    
    private var shapeLayer: CALayer?
    private var middleImageView = UIImageView()
    private lazy var buttonBackgroundView = UIView()
    
    let errorMessage: UILabel = {
        let label = UILabel()
        label.text = "Ошибка при сканировании, попробуйте еще раз"
        return label
    }()
    
    private lazy var searchBar = UISearchBar()
    
    let profileImage = UIImage(named: "profile")
    let homeImage = UIImage(named: "home")
    
    var uid = "wTkLYYvYSYaH3DClKLxG"
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupTabBar()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        delegate = self
        setupButtonView()
        setupMiddleImage()
    }
    
    private func setupButtonView() {
        buttonBackgroundView = UIView(frame: CGRect(x: (view.bounds.width / 2) - 35, y: -35, width: 70, height: 70))
        buttonBackgroundView.layer.shadowColor = UIColor.black.cgColor
        buttonBackgroundView.layer.cornerRadius = 68 / 2
        buttonBackgroundView.backgroundColor = #colorLiteral(red: 0.7294117647, green: 1, blue: 0.9411764706, alpha: 1)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToQR))
        buttonBackgroundView.addGestureRecognizer(gesture)
        tabBar.addSubview(buttonBackgroundView)
        view.layoutIfNeeded()
    }
    
    private func setupMiddleImage() {
        middleImageView = UIImageView(frame: CGRect(x: (view.bounds.width / 2) - 12, y: -12, width: 25, height: 25))
        middleImageView.image = UIImage(named: "qrIcon")
        tabBar.addSubview(middleImageView)
    }
  
    @objc private func moveToQR() {
        self.selectedIndex = 1
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.clear.cgColor

        
        let restVC = UINavigationController(rootViewController:RestaurantsViewController())
        restVC.tabBarItem.image = homeImage
        restVC.tabBarItem.title = "Рестораны"
        
        let emptyVC = UINavigationController(rootViewController: QRScannerViewController())
        
        let profileVC = UINavigationController(rootViewController: UserProfileViewController())
        profileVC.tabBarItem.image = profileImage
        profileVC.tabBarItem.title = "Профиль"
        
        viewControllers = [restVC, emptyVC, profileVC]

        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        }

    }
}

extension MainTabBar: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 && Auth.auth().currentUser == nil{
            tabBarController.selectedIndex = 0
            let navVC = tabBarController.selectedViewController as? UINavigationController
            navVC?.popToRootViewController(animated: true)
            let restVC = navVC?.rootViewController as? RestaurantsViewController
            restVC?.checkAuth()
        }
    }
}
