//
//  SelectCardViewController.swift
//  QrRestaurantMenuApp
//
//  Created by IOS-Developer on 17.06.2021.
//

import UIKit
import FloatingPanel
import FirebaseFirestore
import SnapKit

class SelectCardViewController: UIViewController {
    
    let db = Firestore.firestore()
    var orderItems: [MenuItem : Int] = [:]
    var menuItems: [MenuItem] = []
    var totalPrice: Double?
    var totalCount: Int?
    var result: String = ""
    var restaurants: [Restaurant] = []
    var card: Card? {
        didSet {
            payButton.isEnabled = true
            payButton.alpha = 1
        }
    }

    
    private var cardsCondition: [Card: Bool] = [:]
    private var newCards: [String: Any]? {
        didSet {
            parseDataToCards()
        }
    }
    
    var cards: [Card]? {
        didSet {
            cardTableView.reloadData()
        }
    }
    var uid: String? = "wTkLYYvYSYaH3DClKLxG"
    
    private let selectCardLabel: UILabel = {
        let label = UILabel()
        label.text = "Выбор карты"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "remove"), for: .normal)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    private let spaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let cardTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.register(SelectedCardCell.self, forCellReuseIdentifier: SelectedCardCell.selectID)
        tableView.register(SelectedFooter.self, forHeaderFooterViewReuseIdentifier: "footerID")
        return tableView
    }()
    
    private let payButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.411716789, green: 0.4117922783, blue: 0.4117119908, alpha: 1)
        button.isEnabled = false
        button.alpha = 0.5
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(transitionToResultOfPayment), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cardTableView.delegate = self
        cardTableView.dataSource = self
        configureUI()
        QRFirebaseDatabase.shared.getCardsOfUser(uid: uid ?? "") { [weak self] cards in
            self?.newCards = cards
        }
    }
    
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func transitionToResultOfPayment() {
        if validationFunc() == true {
            let orderVC = OrderSuccessfulViewController()
            orderVC.totalPrice = totalPrice
            orderVC.totalCount = totalCount
            orderVC.orderItems = orderItems
            orderVC.result = result
            orderVC.restaurants = restaurants
            navigationController?.pushViewController(orderVC, animated: true)
        } else {
            let orderFailureVC = OrderFailedViewController()            
            navigationController?.pushViewController(orderFailureVC, animated: true)
        }
    }        
    
    private func validationFunc() -> Bool {
        guard let numberCard = card?.cardNumber else { return false }
        if numberCard.starts(with: "3") || numberCard.starts(with: "4") || numberCard.starts(with: "5") || numberCard.starts(with: "6") {
            return true
        }
        return false
    }
    
    private func configureUI() {
        view.addSubview(selectCardLabel)
        view.addSubview(cancelButton)
        view.addSubview(cardTableView)
        view.addSubview(payButton)
        
        selectCardLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(20)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
        }
        cardTableView.snp.makeConstraints {
            $0.top.equalTo(selectCardLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(250)
        }
        payButton.snp.makeConstraints {
            $0.top.equalTo(cardTableView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(53)
        }
    }
    
    private func moveToAddCards() {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите \nдобавить карту?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self]  action in
             let addCardVC = AddCardViewController()
            addCardVC.saveCard = { [weak self] in
                guard let uid = self?.uid else { return }
                QRFirebaseDatabase.shared.getCardsOfUser(uid: uid) { [weak self] (cards) in
                    self?.newCards = cards
                }
            }
             self?.navigationController?.present(addCardVC, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func parseDataToCards() {
        var updateCards: [Card] = []
        newCards?.forEach({ key, value in
            let info = value as? [String: Any]
            let cardNumber = info?["numberCard"] as? String
            let cardHolderName = info?["holderName"] as? String
            let cvv = info?["cvv"] as? String
            let dateMonth = info?["validMonth"] as? String
            let dateYear = info?["validYear"] as? String
            let card = Card(cardHolderName: cardHolderName, cardNumber: cardNumber, dateMonth: dateMonth, dateYear: dateYear, cvv: cvv, key: key)
            updateCards.append(card)
        })
        DispatchQueue.main.async {
            self.cards = updateCards
        }
        
    }
    
    private func checkCard(_ card: Card) -> Bool {
        
        return true
    }
}
extension SelectCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedCardCell.selectID, for: indexPath) as! SelectedCardCell
        cell.card = cards?[indexPath.row]
        if cardsCondition[cell.card!] == true {
            cell.fillDot()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: SelectedFooter.footerID) as! SelectedFooter
        footer.payCard = { [weak self] in self?.moveToAddCards() }
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
extension SelectCardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SelectedCardCell
        cardsCondition[card!] = false
        cell?.removeDot()
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as? SelectedCardCell
        cardsCondition[(currentCell?.card)!] = true
        card = currentCell?.card
        currentCell?.fillDot()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
