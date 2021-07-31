//
//  OrderSuccessfulTableViewFooter.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 17.06.2021.
//

import UIKit

class OrderSuccessfulTableViewFooter: UITableViewHeaderFooterView {

    static let identifier = "tableViewFooter"
    var totalPrice: Double = 0{
        didSet {
            priceLabel.text = "\(totalPrice) T"
        }
    }
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
        return view
    }()
    
    private let overallLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Итого"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0 T"
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = #colorLiteral(red: 0.7953980565, green: 0.7514889836, blue: 0.7521407008, alpha: 1)
        addSubview(lineView)
        addSubview(overallLabel)
        addSubview(priceLabel)
        lineView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(1)
        }
        overallLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(10)
        }
        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
