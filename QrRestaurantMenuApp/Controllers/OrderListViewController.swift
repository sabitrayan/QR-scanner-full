//
//  OrderListViewController.swift
//  QrRestaurantMenuApp
//
//  Created by ryan on 6/20/21.
//

import UIKit
import FloatingPanel
import Firebase

class OrderListViewController: UIViewController {

    var order: Order? {
        didSet {
            assignOrderItems()            
        }
    }
    
    var restaurants: [Restaurant] = []
    
    var orderItems: [OrderItem] = []
    
    var floationgPanel = FloatingPanelController()
    
    private let orderTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
        tableView.register(OrderFooter.self, forHeaderFooterViewReuseIdentifier: "footerID")
        tableView.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()


    func parseOrderToMenu(order: Order) -> [MenuItem]{
        var menuItems: [MenuItem] = []
        order.orderItems?.forEach({ key, orderItem in
            menuItems.append(MenuItem(id: orderItem.id, categoryId: orderItem.categoryId, description: orderItem.description, imageUrl: orderItem.imageUrl, name: orderItem.name, price: orderItem.price, restaurantId: orderItem.restaurantId))
        })
        return menuItems
    }

    func parseOrderToBasket(order: Order) -> [MenuItem : Int]{
        var menuItems: [MenuItem : Int] = [:]
        order.orderItems?.forEach({ key, orderItem in
            menuItems[MenuItem(id: orderItem.id, categoryId: orderItem.categoryId, description: orderItem.description, imageUrl: orderItem.imageUrl, name: orderItem.name, price: orderItem.price, restaurantId: orderItem.restaurantId)] = orderItem.count
        })
        return menuItems
    }
    
    private func getRestaurants(){
        Firestore.firestore().collection("restoran").addSnapshotListener { querySnapShot, error in
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
                self.restaurants = arr
            }
            
        }
    }
    
    @objc func orderAgain() {
        let selectVC = SelectCardViewController()
        guard let order = order else {return}
        selectVC.totalPrice = order.totalPrice
        selectVC.menuItems = parseOrderToMenu(order: order)
        selectVC.orderItems = parseOrderToBasket(order: order)
        selectVC.restaurants = restaurants
        floationgPanel.addPanel(toParent: self, at: 3, animated: true) {
            self.floationgPanel.set(contentViewController: selectVC)
        }
    }

    func assignOrderItems(){
        order?.orderItems?.forEach({ key, orderItem in
            orderItems.append(orderItem)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        getRestaurants()
        setupTableView()
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(popVC))
        let titleStackView = TabBarTitleView()
        titleStackView.title = "История заказов"
        tabBarController?.navigationItem.titleView = titleStackView
    }
    
    @objc private func popVC(){
        _ = navigationController?.popViewController(animated: true)
    }

    private func setupTableView(){
        view.addSubview(orderTableView)
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.bottom.equalToSuperview()
        }
    }

}


extension OrderListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
        cell.orderItem = orderItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderFooter.footerID) as! OrderFooter
        footer.delegate = self
        footer.order = order
        return footer
    }
}

extension OrderListViewController: OrderFooterDelegate {
    func orderButtonTapped() {
        
    }
    
    
}
