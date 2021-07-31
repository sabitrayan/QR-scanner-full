//
//  SnackBarFooter.swift
//  QrRestaurantMenuApp
//
//  Created by IOS-Developer on 17.06.2021.
//

import UIKit

class SelectedFooter: UITableViewHeaderFooterView {
    var payCard: (() -> Void)?
    static var footerID = "footerID"
    
    private let addCardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.addTarget(self, action: #selector(moveToAddCard), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)        
        return button
    }()
    private let iconDestenation: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.image = UIImage(named: "NextArrowIcon")
        return icon
    }()
    private let addCardLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить карту"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addViewAndContstraints()
    }
 
    @objc private func moveToAddCard() {
      payCard?()
    }
    private func addViewAndContstraints() {
        
        contentView.addSubview(addCardLabel)
        contentView.addSubview(iconDestenation)
        contentView.addSubview(addCardButton)
        
        addCardLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
        }
        
        iconDestenation.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(19)
            $0.right.equalToSuperview().inset(19.69)
            $0.width.height.equalTo(15)
        }
        
        addCardButton.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
