//
//  OrderSuccessfulTableViewHeader.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 17.06.2021.
//

import UIKit

class OrderSuccessfulTableViewHeader: UITableViewHeaderFooterView {

    static let identifier = "tableHeader"
    
    var restaurantName: String? {
        didSet {
            nameLabel.text = restaurantName
        }
    }
    var seatNumber: String? {
        didSet {
            seatLabel.text = seatNumber
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Luckee Yu"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let seatLabel: UILabel = {
        let label = UILabel()
        label.text = "Стол №5"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = #colorLiteral(red: 0.7953980565, green: 0.7514889836, blue: 0.7521407008, alpha: 1)
        addSubview(nameLabel)
        addSubview(seatLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        }
        seatLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
