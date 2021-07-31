//
//  OrderSuccessfulViewController.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 17.06.2021.
//

import UIKit
import Firebase

class OrderSuccessfulViewController: UIViewController {
    var orders: [String : Any] = [:]
    var orderList: [String : Order] = [:]
    var orderItems: [MenuItem : Int] = [:]
    var menuItems: [MenuItem] = []
    var totalPrice: Double?
    var totalCount: Int?
    var result: String = ""
    var restaurants: [Restaurant] = []
    var uid: String = "wTkLYYvYSYaH3DClKLxG"
    
    private let doneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "doneIcon")
        return imageView
    }()
    
    private let doneLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш заказ успешно оплачен!"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let orderTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderSuccessfulTableViewCell.self, forCellReuseIdentifier: OrderSuccessfulTableViewCell.identifier)
        tableView.register(OrderSuccessfulTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "tableHeader")
        tableView.register(OrderSuccessfulTableViewFooter.self, forHeaderFooterViewReuseIdentifier: "tableViewFooter")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .none
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
        
    private lazy var exitButton: UIButton = {
        var button = UIButton()
        button.setTitle("На главную", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.4862297773, green: 0.4863032103, blue: 0.4862136245, alpha: 1)
        button.addTarget(self, action: #selector(transitionToRootVC), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        orderTableView.dataSource = self
        orderTableView.delegate = self
        dataParseToMenuItems()
        view.backgroundColor = #colorLiteral(red: 0.7958194613, green: 0.7514733672, blue: 0.7521334291, alpha: 1)
        setupConstraints()
        getOrdersOfUser()
        tabBarController?.navigationItem.leftBarButtonItem = nil
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.leftBarButtonItem = nil
        tabBarController?.navigationItem.title = setRestaurantName(id: String(result.split(separator: "_")[0]))
    }
        
    private func setRestaurantName(id: String) -> String {
        var name = ""
        restaurants.forEach { restaurant in
            guard let restId = restaurant.id else {return}
            if String(restId) == id {
                guard let restName = restaurant.rest_name else {return}
                name = restName
            }
        }
        return name
    }
    
    @objc private func transitionToRootVC(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func addItemsToOrderHistory(){
        orderList.forEach { key, order in
            var orderItems: [String : Any] = [:]
            order.orderItems?.forEach({ key, orderItem in
                var orderItemsDict: [String : Any] = [:]
                orderItemsDict["id"] = orderItem.name
                orderItemsDict["categoryId"] = orderItem.categoryId
                orderItemsDict["name"] = orderItem.name
                orderItemsDict["imageUrl"] = orderItem.imageUrl
                orderItemsDict["description"] = orderItem.description
                orderItemsDict["count"] = orderItem.count
                orderItemsDict["price"] = orderItem.price
                orderItems[key] = orderItemsDict
            })
            
            orders[key] = ["restaurantName" : order.restaurantName, "date" : order.date, "totalPrice" : order.totalPrice, "seatNumber" : order.seatNumber, "orderItems" : orderItems]
        }
        
        var orderItems: [String : Any] = [:]
        self.orderItems.forEach { menuItem, count in
            let orderItem = OrderItem(id: menuItem.id ?? -1, categoryId: menuItem.categoryId ?? -1, description: menuItem.description, imageUrl: menuItem.imageUrl, name: menuItem.name, price: menuItem.price, restaurantId: menuItem.restaurantId, count: count)
            var orderItemsDict: [String : Any] = [:]
            orderItemsDict["name"] = orderItem.name
            orderItemsDict["imageUrl"] = orderItem.imageUrl
            orderItemsDict["description"] = orderItem.description
            orderItemsDict["count"] = orderItem.count
            orderItemsDict["price"] = orderItem.price
            guard let name = orderItem.name else {return}
            orderItems["order: \(name)"] = orderItemsDict
            
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let formatterForDict = DateFormatter()
        formatterForDict.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        let restInfo = self.result.split(separator: "_")
        self.orders[result] = ["restaurantName" : setRestaurantName(id: String(restInfo[0])), "date" : formatterForDict.string(from: date), "totalPrice" : totalPrice, "seatNumber" : "Стол №\(restInfo[1])", "orderItems" : orderItems]
        // let order = Order(restaurantName: "Luckee Yu", date: result, totalPrice: self.totalPrice, seatNumber: "Стол №5", orderItems: orderItems)
        DispatchQueue.main.async {
            Firestore.firestore().collection("users").document(self.uid).updateData([
                "orders" : self.orders
            ]) { error in
                guard let err = error else {return}
                print(err.localizedDescription)
            }
        }
    }
    
    private func getOrdersOfUser() {
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.getDocument { documentSnapshot, _ in
            if let document = documentSnapshot, document.exists {
                guard let data = document.data() else { return }
                let orders = data["orders"] as? [String : Any] ?? [:]
                var orderList: [String : Order] = [:]
                orders.forEach { key, order in
                    let orderData = orders[key] as? [String : Any] ?? [:]
                    let date = orderData["date"] as? String ?? ""
                    let restaurantName = orderData["restaurantName"] as? String ?? ""
                    let seatNumber = orderData["seatNumber"] as? String ?? ""
                    let totalPrice = orderData["totalPrice"] as? Double ?? 0
                    let orderItems = orderData["orderItems"] as? [String : Any] ?? [:]
                    var orderItemList: [String : OrderItem] = [:]
                    orderItems.forEach { key, orderItem in
                        let orderItemData = orderItems[key] as? [String : Any] ?? [:]
                        let id = orderItemData["id"] as? Int ?? 0
                        let categoryId = orderItemData["categoryId"] as? Int ?? 0
                        let description = orderItemData["description"] as? String ?? ""
                        let name = orderItemData["name"] as? String ?? ""
                        let imageUrl = orderItemData["imageUrl"] as? String ?? ""
                        let count = orderItemData["count"] as? Int ?? 0
                        let price = orderItemData["price"] as? Double ?? 0
                        let restaurantId = orderItemData["restaurantId"] as? Int ?? 0
                        let orderItem = OrderItem(id: id, categoryId: categoryId,description: description, imageUrl: imageUrl, name: name, price: price, restaurantId: restaurantId , count: count)
                        orderItemList[key] = orderItem
                    }
                    let order = Order(restaurantName: restaurantName, date: date, totalPrice: totalPrice, seatNumber: seatNumber, orderItems: orderItemList)
                    orderList[key] = order
                }
                DispatchQueue.main.async {
                    self.orderList = orderList
                    self.addItemsToOrderHistory()
                }
            }
        }
    }
    
    func dataParseToMenuItems(){
        orderItems.keys.forEach { menuItem in
            menuItems.append(menuItem)
        }
    }
    
    func setupViews(){
        view.addSubview(doneImageView)
        view.addSubview(doneLabel)
        view.addSubview(orderTableView)
        view.addSubview(exitButton)
    }
    
    func setupConstraints(){
        doneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        doneLabel.snp.makeConstraints { make in
            make.top.equalTo(doneImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        orderTableView.snp.makeConstraints { make in
            make.top.equalTo(doneLabel.snp.bottom).offset(30)
            make.right.left.equalToSuperview().inset(30)
            make.height.equalTo(250)
        }
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(orderTableView.snp.bottom).offset(50)
            make.right.left.equalToSuperview().inset(30)
            make.height.equalTo(55)
        }
    }
}


extension OrderSuccessfulViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderSuccessfulTableViewCell.identifier, for: indexPath) as! OrderSuccessfulTableViewCell
        cell.count = orderItems[menuItems[indexPath.row]]
        cell.menuItem = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderSuccessfulTableViewFooter.identifier) as! OrderSuccessfulTableViewFooter
        if let price = totalPrice {
            view.totalPrice = price
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderSuccessfulTableViewHeader.identifier) as! OrderSuccessfulTableViewHeader
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension UINavigationController {

    var rootViewController: UIViewController? {
        return viewControllers.first
    }

}
