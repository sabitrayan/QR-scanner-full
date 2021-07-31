//
//  RestaurantsViewController.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 31.05.2021.
//

import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import FloatingPanel

class RestaurantsViewController: UIViewController  {
    
    var result = "You got it!!!"
    
    var floatingPanel = FloatingPanelController()
    private var restaurant: [Restaurant] = [] {
        didSet {
            restarauntTableView.reloadData()
        }
    }
    
    private var restaurantForTableView: [Restaurant] = [] {
        didSet {
            restarauntTableView.reloadData()
        }
    }
    
    private var db = Firestore.firestore()
            
    private lazy var searchBar = UISearchBar()
    
    private let restarauntTableView: UITableView = {
        let table = UITableView()
        table.register(RestaurantsTableViewCell.self, forCellReuseIdentifier: RestaurantsTableViewCell.identifire)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        restarauntTableView.delegate = self
        restarauntTableView.dataSource = self
        view.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        setupViews()
        setupConstraints()
        getRestaurants()
        floatingPanel.delegate = self
        floatingPanel.contentMode = .fitToBounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
        tabBarController?.navigationItem.leftBarButtonItem = nil        
    }
      
    func setupNavigationController(){
        searchBar.sizeToFit()
        let titleStackView = TabBarTitleView()
        titleStackView.title = "Ресторан"
        tabBarController?.navigationItem.titleView = titleStackView
        tabBarController?.navigationController?.navigationBar.barTintColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        tabBarController?.navigationController?.navigationBar.tintColor = .black
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.delegate = self
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func handleSearchBar(){
        tabBarController?.navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        tabBarController?.navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    private func getRestaurantsByName(name: String) {
        restaurantForTableView = []
        restaurant.forEach { restaurant in
            guard let resName = restaurant.rest_name else {return}
            if resName.lowercased().contains(name.lowercased()) {
                restaurantForTableView.append(restaurant)
            }
        }
    }
    
    func checkAuth() {
        if Auth.auth().currentUser?.uid == nil {
            let child = SnackbarViewController()
            floatingPanel.addPanel(toParent: self, at: 3, animated: true){
                self.floatingPanel.set(contentViewController: child)
            }
        }
    }
    
    private func getRestaurants(){
        db.collection("restoran").addSnapshotListener { querySnapShot, error in
            guard let documents = querySnapShot?.documents else{
                print("No Documents")
                return
            }
            var arr: [Restaurant] = []
            documents.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? Int ?? 0
                let desc = data["rest_description"] as? String ?? ""
                let restLoc = data["rest_locations"] as? [String] ?? []
                let name = data["rest_name"] as? String ?? ""
                let restImg = data["rest_image_url"] as? String ?? ""
                var locArr: [String] = []
                restLoc.forEach { location in
                    locArr.append(location)
                }
                let restorant = Restaurant(id: id, rest_name: name, rest_description: desc, rest_image_url: restImg, rest_location: locArr)
                arr.append(restorant)                
            }
            
            DispatchQueue.main.async {
                self.restaurant = arr
                self.restaurantForTableView = self.restaurant
            }
        }
    }

    func setupViews(){
        view.addSubview(restarauntTableView)
    }
    
    func setupConstraints(){
        restarauntTableView.frame = view.bounds
    }
}

extension RestaurantsViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantForTableView.count        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantsTableViewCell.identifire, for: indexPath) as! RestaurantsTableViewCell
        
        cell.restItem = restaurantForTableView[indexPath.row]
       
        return cell
        
    }
}

extension RestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuVC = RestoranInfoViewController()
        menuVC.restaurant = restaurantForTableView[indexPath.row]
        navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension RestaurantsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let titleStackView = TabBarTitleView()
        titleStackView.title = "Ресторан"
        tabBarController?.navigationItem.titleView = titleStackView
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            restaurantForTableView = restaurant
        }else {
            getRestaurantsByName(name: searchText)
        }
    }
}

extension RestaurantsViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor size: CGSize) -> FloatingPanelLayout {
        return MyFloatingPanelLayout()
    }

    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return MyFloatingPanelLayout()
    }
}
