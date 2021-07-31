//
//  CardViewController.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 9.06.2021.
//

import UIKit
import FirebaseFirestore
import SnapKit
import FloatingPanel

class CardViewController: UIViewController {

    var floatingPanel = FloatingPanelController()
    private var newCards: [String: Any]? {
        didSet {
            parseDataToCards()
        }
    }
    private var db = Firestore.firestore()
    var cards: [Card]? {
        didSet {
            cardTableView.reloadData()
        }
    }
    
    var uid: String? = "wTkLYYvYSYaH3DClKLxG"
    private let cardTableView: UITableView = {
        let table = UITableView()
        table.register(CardCellTableViewCell.self, forCellReuseIdentifier: CardCellTableViewCell.cardCell)
        table.register(FooterView.self, forHeaderFooterViewReuseIdentifier: "footerID")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupTableView()
        setupConstraintsTableView()
        floatingPanel.surfaceView.grabberHandle.isHidden = true
        title = "Мои карты"
        floatingPanel.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        QRFirebaseDatabase.shared.getCardsOfUser(uid: uid ?? "") { [weak self] cards in
            self?.newCards = cards
        }
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(popVC))
    }
    
    @objc private func popVC(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(cardTableView)
        cardTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cardTableView.delegate = self
        cardTableView.dataSource = self
    }
    
    private func setupConstraintsTableView() {
        cardTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.left.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    private func moveToAddCards() {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите \nдобавить карту?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self]  action in
            self?.floating()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func floating() {
        let addCardVC = AddCardViewController()
        floatingPanel.addPanel(toParent: self, at: 3, animated: true) { [weak self] in
            addCardVC.saveCard = { [weak self] in
                guard let uid = self?.uid else { return }
                QRFirebaseDatabase.shared.getCardsOfUser(uid: uid) { [weak self] (cards) in
                    self?.newCards = cards
                }
            }
            self?.floatingPanel.set(contentViewController: addCardVC)
        }
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
        self.cards = updateCards
    }
}
extension CardViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardCellTableViewCell.cardCell, for: indexPath) as! CardCellTableViewCell
        cell.card = cards?[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterView.footerID) as! FooterView
        footer.addCard = { [weak self] in self?.moveToAddCards() }
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}

extension CardViewController: CardCellDelegate {
    func deleteCard(itemCard: Card) {
        newCards?[itemCard.key!] = nil
        cards?.removeAll(where: { card -> Bool in
            if card == itemCard {
                return true
            }
            return false
        })
        db.collection("users").document("wTkLYYvYSYaH3DClKLxG").updateData([
            "cards": newCards as Any
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
            self.cards?.removeAll { item in
                if item == itemCard {
                    return true
                }
                return false
            }
        }
    }
}
extension CardViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return MyCardFloatingPanelLayout()
    }
    
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor size: CGSize) -> FloatingPanelLayout {
        return MyCardFloatingPanelLayout()
    }
}

class MyCardFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 415, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
