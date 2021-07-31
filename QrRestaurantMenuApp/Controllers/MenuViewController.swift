//
//  MenuViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 03.06.2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import SnapKit
import AVFoundation
import FloatingPanel

class MenuViewController: UIViewController {
    
    var session: AVCaptureSession?
    var result: String = "Дареджани_5"
    var countOfItems = 0 {
        didSet{
            basketCountLabel.text = "\(countOfItems)"
        }
    }
    
    var totalPrice: Double = 0 {
        didSet{
            basketTotalPriceLabel.text = "\(totalPrice) \u{20B8}"
        }
    }
    
    var basketItems: [MenuItem : Int] = [:] {
        didSet {
            menuTableView.reloadData()
        }
    }
    
    var categoriesForTableView: [Category] = [] {
        didSet{
            menuTableView.reloadData()
        }
    }
    
    private var categories: [Category] = [] {
        didSet {
            categoryCollectionView.reloadData()
            menuTableView.reloadData()
        }
    }
    
    var menuItems: [Int : [MenuItem]] = [:] {
        didSet {
            menuTableView.reloadData()
        }
    }
    
    var menuItemsForTableView: [Int : [MenuItem]] = [:] {
        didSet {
            menuTableView.reloadData()
        }
    }
    private var db = Firestore.firestore()
    
    private lazy var searchBar = UISearchBar()
    
    private let categoryCollectionView: UICollectionView = {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .horizontal
        layer.minimumLineSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layer)
        collection.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        collection.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.restaurantId)
        return collection
    }()
    private let menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.4, green: 0.949, blue: 0.831, alpha: 1)
        view.layer.cornerRadius = 10
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let basketButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.addTarget(self, action: #selector(basketViewOnTapped), for: .touchUpInside)
        return button
    }()
    
    private let basketNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш заказ"
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        return label
    }()
    
    private let basketCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        return label
    }()
    
    private let basketTotalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        return label
    }()
    
    private let searchErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 11.5)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.isHidden = true
        label.text = "К сожалению, по вашему запросу ничего не найдено"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        setupTableView()
        getCategories()
        getMenuItems()
        setupBasketView()
        view.addSubview(searchErrorLabel)
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    func setupBasketView(){
        view.addSubview(basketView)
        basketView.addSubview(basketNameLabel)
        basketView.addSubview(basketCountLabel)
        basketView.addSubview(basketTotalPriceLabel)
        basketView.addSubview(basketButton)
    }
    
    
    func setupNavigationController(){
        searchBar.sizeToFit()
        tabBarController?.navigationController?.navigationBar.barTintColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        tabBarController?.navigationController?.navigationBar.tintColor = .black
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.delegate = self
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(popVC))
        navigationController?.navigationBar.isHidden = true
        let stackView = TabBarTitleView()
        stackView.title = getRestaurantName()
        stackView.subTitle = getSeatNumber()
        tabBarController?.navigationItem.titleView = stackView        
    }
    
    private func getRestaurantName() -> String{
        return String(result.split(separator: "_")[0])
    }
    
    private func getSeatNumber() -> String {
        return "Стол №\(result.split(separator: "_")[1])"
    }
    
    @objc func popVC(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSearchBar(){
        tabBarController?.navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        tabBarController?.navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    @objc func basketViewOnTapped(){
        let vc = BasketViewController()
        vc.delegate = self
        vc.basketMenu = basketItems
        vc.totalPrice = totalPrice
        vc.counter = countOfItems
        vc.result = result
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func setupTableView() {
        view.addSubview(categoryCollectionView)
        view.addSubview(menuTableView)
        menuTableView.register(SectionView.self, forHeaderFooterViewReuseIdentifier: SectionView.identifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self        
        menuTableView.dataSource = self
        menuTableView.delegate = self
    }
    
    private func setupConstraints() {
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        menuTableView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(130)
        }
        basketView.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(100)
            $0.height.equalTo(50)
        }
        basketButton.snp.makeConstraints{
            $0.left.right.bottom.top.equalToSuperview()
        }
        basketNameLabel.snp.makeConstraints{
            $0.centerY.equalTo(basketView.snp.centerY)
            $0.left.equalTo(basketView.snp.left).inset(15)
        }
        basketCountLabel.snp.makeConstraints{
            $0.centerY.equalTo(basketView.snp.centerY)
            $0.left.equalTo(basketNameLabel.snp.right).offset(5)
        }
        basketTotalPriceLabel.snp.makeConstraints{
            $0.right.equalTo(basketView.snp.right).inset(15)
            $0.centerY.equalTo(basketView.snp.centerY)
        }
        searchErrorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(30)
            make.width.equalTo(192)
            make.height.equalTo(42)
        }
    }
    
    private func getCategories(){
        db.collection("category").addSnapshotListener { querySnapShot, error in
            guard let documents = querySnapShot?.documents else{
                print("No Documents")
                return
            }
            var categories: [Category] = []
            categories.append(Category(id: 0, name: "Все"))
            documents.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? Int ?? 0
                let name = data["name"] as? String ?? ""
                categories.append(Category(id: id, name: name))
            }
            
            DispatchQueue.main.async {
                self.categories = categories
                self.categoriesForTableView = categories
                self.categoriesForTableView.removeAll { category in
                    if category.id == 0 {
                        return true
                    }
                    return false
                }
            }
            
        }
    }
    
    private func getMenuItemsByCategoryId(id: Int){
       
        var menuItems: [Int : [MenuItem]] = [:]
        self.menuItems.forEach { categoryId, menuItem in
            if id == categoryId{
                menuItems[categoryId] = menuItem
            }
        }
        
        DispatchQueue.main.async {
            self.menuItemsForTableView = menuItems
        }
    }
    
    private func getMenuItems() {
        var menuItems: [Int : [MenuItem]] = [:]
        db.collection("menu").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("No Documents")
                return
            }
            documents.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let categoryId = data["categoryID"] as? Int ?? -1
                let description = data["description"] as? String ?? ""
                let imageUrl = data["image"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let price = data["price"] as? Double ?? -1
                let restaurantId = data["restoranId"] as? Int ?? -1
                let id = data["id"] as? Int ?? -1
                let menuItem = MenuItem(id: id, categoryId: categoryId, description: description, imageUrl: imageUrl, name: name, price: price, restaurantId: restaurantId)
                if menuItems[categoryId] == nil {
                    menuItems[categoryId] = []
                }
                menuItems[categoryId]?.append(menuItem)
            }
            DispatchQueue.main.async { [self] in
                self.menuItems = menuItems
                self.menuItemsForTableView = menuItems
            }
        }
    }
}

extension MenuViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        if cell.categoryItem?.id == 0 {
            menuItemsForTableView = menuItems
            categoriesForTableView = categories
            categoriesForTableView.removeAll { category in
                if category.id == 0 {
                    return true
                }
                return false
            }
        }else{
            guard let item = cell.categoryItem else {return}
            guard let id = item.id else {return}
            getMenuItemsByCategoryId(id: id)
            categoriesForTableView = []
            categoriesForTableView.append(item)
        }
        cell.toColorView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        cell.defaultColorView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.restaurantId, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryItem = categories[indexPath.row]
        return cell
        
    }
}
extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 77, height: 28)
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesForTableView.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsForTableView[categoriesForTableView[section].id!]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
        cell.menuItem = menuItemsForTableView[categoriesForTableView[indexPath.section].id!]![indexPath.row]
        cell.delegate = self
        if let count = basketItems[cell.menuItem!] {
            if count > 0 {
                cell.count = count
                cell.setColorButton()
            }
        }
        return cell

    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionView.identifier) as! SectionView
        view.category = categoriesForTableView[section]
        return view
    }
}

extension MenuViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let stackView = TabBarTitleView()
        stackView.title = getRestaurantName()
        stackView.subTitle = getSeatNumber()
        tabBarController?.navigationItem.titleView = stackView
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.showsCancelButton = false
        self.searchErrorLabel.isHidden = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        menuItemsForTableView = [:]
        categoriesForTableView = []
        if searchText == "" {
            self.searchErrorLabel.isHidden = true
            menuItemsForTableView = menuItems
            categoriesForTableView = categories
            categoriesForTableView.removeAll { category in
                if category.id == 0 {
                    return true
                }
                return false
            }
        }else{
            menuItems.forEach { key, menuItem in
                menuItem.forEach { item in
                    guard let name = item.name else {return}
                    guard let description = item.description else {return}
                    if name.lowercased().contains(searchText.lowercased()) || description.lowercased().contains(searchText.lowercased()){
                        if menuItemsForTableView[key] == nil {
                            menuItemsForTableView[key] = []
                        }
                        menuItemsForTableView[key]?.append(item)
                    }
                }
            }
            if menuItemsForTableView.isEmpty {
                self.searchErrorLabel.isHidden = false
            }else{
                self.searchErrorLabel.isHidden = true
            }
            let keys = menuItemsForTableView.keys
            categories.forEach { category in
                if keys.contains(where: { key in
                    if category.id == key {return true}
                    return false
                }){
                    categoriesForTableView.append(category)
                }
            }
        }
    }
}

extension MenuViewController: BasketViewControllerDelegate {
    func popVCPressed(menuItems: [MenuItem], basketMenu: [MenuItem : Int], totalPrice: Double, counter: Int) {
        self.basketItems = basketMenu
        self.basketItems.forEach { menuItem, count in
            if self.basketItems[menuItem] == 0 {
                self.basketItems[menuItem] = nil
            }
        }
        self.totalPrice = totalPrice
        self.countOfItems = counter
        if countOfItems == 0 && totalPrice == 0 {
            basketView.isHidden = true
        }
    }
}

extension MenuViewController: MenuTableViewCellDelegate {
    
    func plusButtonTapped(menuItem: MenuItem, count: Int) {
        guard let price = menuItem.price else {return}
        totalPrice += price
        countOfItems += 1
        if count == 0 {
            basketView.isHidden = false
            basketItems[menuItem] = 1
        } else {
            basketItems[menuItem]! += 1
        }
    }
    
    func minusButtonTapped(menuItem: MenuItem, count: Int) {
        if count > 0 {
            guard let price = menuItem.price else {return}
            totalPrice -= price
            countOfItems -= 1
            if countOfItems == 0 {
                basketView.isHidden = true
            }
            if count - 1 == 0 {
                basketItems[menuItem] = nil
            } else {
                basketItems[menuItem]! -= 1
            }
        }
    }
}
