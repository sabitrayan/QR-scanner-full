//
//  OrderFooter.swift
//  QrRestaurantMenuApp
//
//  Created by IOS-Developer on 20.06.2021.
//

import UIKit

protocol OrderFooterDelegate {
    func orderButtonTapped()
}

class OrderFooter: UITableViewHeaderFooterView {

    static let footerID = "footerID"
    var order: Order? {
        didSet{
            restaurantNameLabel.text = order?.restaurantName
            guard let totalPrice = order?.totalPrice else {return}
            priceLabel.text = "\(totalPrice) \u{20B8}"
            seatLabel.text = order?.seatNumber
            dateLabel.text = order?.date
        }
    }
    var delegate: OrderFooterDelegate?
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        return label
    }()
    
    private let seatLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 14)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 14)
        return label
    }()
    
    private let spaceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private lazy var orderButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 0.729, green: 1, blue: 0.941, alpha: 1)
        button.setTitle("Заказать снова", for: .normal)
        button.setTitleColor(UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 17.5)
        button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        contentView.addSubview(restaurantNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(seatLabel)
        contentView.addSubview(spaceView)
        contentView.addSubview(orderButton)
    }
    
    func setupConstraints(){
        restaurantNameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(20)
        }
        priceLabel.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(20)
        }
        seatLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(restaurantNameLabel.snp.bottom).offset(5)
        }
        dateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
        }
        spaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
        }
        orderButton.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview().inset(20)
            make.top.equalTo(spaceView.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func orderButtonTapped(){
        delegate?.orderButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
