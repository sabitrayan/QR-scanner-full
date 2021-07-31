//
//  BasketViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 07.06.2021.
//

import UIKit
import FirebaseFirestore
import SnapKit
import FloatingPanel
import Firebase

protocol BasketViewControllerDelegate {
    func popVCPressed(menuItems: [MenuItem], basketMenu: [MenuItem : Int], totalPrice: Double, counter: Int)
}

class BasketViewController: UIViewController {
    var result: String = ""
    var floatingPanel = FloatingPanelController()
    var basketMenu: [MenuItem : Int] = [:] {
        didSet {
            basketTableView.reloadData()
        }
    }
    var menuItems: [MenuItem] = [] {
        didSet {
            basketTableView.reloadData()
        }
    }
    
    var delegate: BasketViewControllerDelegate?
        
    var counter = 0 {
        didSet {
            if counter == 0 {
                payButton.alpha = 0.5
                payButton.isEnabled = false
            } else if counter > 0 {
                payButton.alpha = 1
                payButton.isEnabled = true
            }
        }
    }
    
    var totalPrice: Double = 0 {
        didSet{
            priceLabel.text = "\(totalPrice) \u{20B8}"
        }
    }

    private let basketTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BasketTableViewCell.self, forCellReuseIdentifier: BasketTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let bottomView = UIView()
    
    private let commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        button.backgroundColor = .none
        return button
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.text = "Добавить комментарий"
        label.font = UIFont(name: "Inter-Medium", size: 14)
        return label
    }()
    
    private let commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NextArrowIcon")
        return imageView
    }()
    
    private let spaceView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private let spaceView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.text = "Итого"
        label.font = UIFont(name: "Inter-Medium", size: 14)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.text = "0"
        label.font = UIFont(name: "Inter-Medium", size: 14)
        return label
    }()
    
    private let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var payButton: UIButton = {
        var button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 17.5)
        button.addTarget(self, action: #selector(basketViewOnTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.729, green: 1, blue: 0.941, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        floatingPanel.delegate = self
        setupTableView()        
        setupPayView()
        floatingPanel.contentMode = .fitToBounds
        setupConstraints()
        parseMenuData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    private func setupPayView() {
        view.addSubview(bottomView)
        bottomView.addSubview(commentView)
        bottomView.addSubview(spaceView1)
        bottomView.addSubview(totalView)
        bottomView.addSubview(spaceView2)
        bottomView.addSubview(buttonView)
        commentView.addSubview(commentLabel)
        commentView.addSubview(commentImageView)
        commentView.addSubview(commentButton)
        totalView.addSubview(totalLabel)
        totalView.addSubview(priceLabel)
        buttonView.addSubview(payButton)
    }
    
    private func getRestaurantName() -> String{
        return String(result.split(separator: "_")[0])
    }
    
    private func getSeatNumber() -> String {
        return "Стол №\(result.split(separator: "_")[1])"
    }
    
    @objc func commentTapped(){
        let vc = CommentViewController()
        floatingPanel.addPanel(toParent: self, at: 3, animated: true) {
            self.floatingPanel.set(contentViewController: vc)
        }
    }
    
    private func setupNavigationController() {
        tabBarController?.navigationController?.navigationBar.barTintColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        tabBarController?.navigationController?.navigationBar.tintColor = .black
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(popVC))
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Очистить", style: .plain, target: self, action: #selector(clearItems))
        navigationController?.navigationBar.isHidden = true
        let stackView = TabBarTitleView()
        stackView.title = "Ваш заказ"
        stackView.subTitle = getSeatNumber()
        tabBarController?.navigationItem.titleView = stackView
    }
    
    @objc func clearItems(){
        menuItems = []
        basketMenu = [:]
        counter = 0
        totalPrice = 0
        popVC()
    }
    
    @objc func popVC(){
        delegate?.popVCPressed(menuItems: menuItems, basketMenu: basketMenu, totalPrice: totalPrice, counter: counter)
        navigationController?.popViewController(animated: true)
    }
    private func checkAuth() {
        print("suka")
    
        if Auth.auth().currentUser?.uid == "" {
            let child = SnackbarViewController()
            floatingPanel.addPanel(toParent: self, at: 3, animated: true){
                self.floatingPanel.set(contentViewController: child)
            }

        }
    }
    @objc func basketViewOnTapped() {
        checkAuth()
        let selectVC = SelectCardViewController()
        selectVC.totalCount = counter
        selectVC.totalPrice = totalPrice
        selectVC.menuItems = menuItems
        selectVC.orderItems = basketMenu
        selectVC.result = result
        floatingPanel.addPanel(toParent: self, at: 3, animated: true) {
            self.floatingPanel.set(contentViewController: selectVC)
        }
    }

    private func parseMenuData() {
        menuItems = Array(basketMenu.keys)
    }
    
    private func setupTableView() {
        view.addSubview(basketTableView)
        basketTableView.dataSource = self
        basketTableView.delegate = self
    }
    
    private func setupConstraints() {
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(120)
            make.height.equalTo(375)
        }
        buttonView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(90)
        }
        payButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        spaceView1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(buttonView.snp.top)
        }
        totalView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(spaceView1.snp.top)
            make.height.equalTo(57)
        }
        totalLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        spaceView2.snp.makeConstraints { make in
            make.bottom.equalTo(totalView.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        commentView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(spaceView2.snp.top)
        }
        commentButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        commentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        commentImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(27)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(16)
        }
        basketTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalTo(commentView.snp.top)
        }
    }
}
extension BasketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier, for: indexPath) as! BasketTableViewCell        
        cell.menuItem = menuItems[indexPath.row]
        if let count = basketMenu[cell.menuItem!]{
        if count > 0  {
            cell.count = count
            cell.setColorButton()
            }
        }
        cell.delegate = self
        return cell
    }
}

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}

extension BasketViewController: BasketTableViewCellDelegate{
    func plusButtonTapped(menuItem: MenuItem, count: Int) {
        guard let price = menuItem.price else {return}
        totalPrice += price
        counter += 1
        if count == 0 {
            basketMenu[menuItem] = 1
        } else {
            basketMenu[menuItem]! += 1
        }
    }
    
    func minusButtonTapped(menuItem: MenuItem, count: Int) {
        if count > 0 {
            guard let price = menuItem.price else {return}
            totalPrice -= price
            counter -= 1
            if count == 0 {
                basketMenu[menuItem] = nil
            } else {
                basketMenu[menuItem]! -= 1
            }
        }
    }
    
    func closeButtonTapped(menuItem: MenuItem, count: Int) {
        menuItems.removeAll { item in
            if item == menuItem {
                return true
            }
            return false
        }
        basketMenu[menuItem] = nil
        guard let price = menuItem.price else {return}
        totalPrice -= price * Double(count)
        counter -= count
        if menuItems.isEmpty {
            payButton.isEnabled = false
            payButton.alpha = 0.5
        }
    }
}
extension BasketViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return MyFloatingPanelLayout()
    }
    
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor size: CGSize) -> FloatingPanelLayout {
        return MyFloatingPanelLayout()
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16, edge: .top, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 415, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
