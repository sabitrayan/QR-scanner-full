//
//  OrderSuccessfulTableViewCell.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 17.06.2021.
//

import UIKit

class OrderSuccessfulTableViewCell: UITableViewCell {

    static let identifier = "orderCell"
    var count: Int?
    var menuItem: MenuItem? {
        didSet {
            let totalPrice = Double(count!) * (menuItem?.price)!
            nameLabel.text = menuItem?.name
            priceLabel.text = "\(count ?? 0) x \(menuItem?.price ?? 0) = \(totalPrice)"
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.7953980565, green: 0.7514889836, blue: 0.7521407008, alpha: 1)
        addSubview(nameLabel)
        addSubview(priceLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.top.equalToSuperview().inset(5)
            make.width.equalTo(150)
        }
        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.top.equalToSuperview().inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
