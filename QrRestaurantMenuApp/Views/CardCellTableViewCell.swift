//
//  CardCellTableViewCell.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 9.06.2021.
//

import UIKit
import SnapKit

protocol CardCellDelegate: class {
    func deleteCard(itemCard: Card)
}

class CardCellTableViewCell: UITableViewCell {
    
    var key: String?
    static var cardCell = "cardCell"
    weak var delegate: CardCellDelegate?
    
    private let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let dotIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "dotIcon")
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    lazy var removeButton: UIButton = {
        let removeBtn = UIButton()
        removeBtn.setImage(UIImage(named: "CloseButton"), for: .normal)
        removeBtn.addTarget(self, action: #selector(removeCard), for: .touchUpInside)
        return removeBtn
    }()
    private let cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 3
        return stackView
    }()
    
    private let nameCardLabel: UILabel = {
        let name = UILabel()
        name.text = "MasterCard"
        name.font = .systemFont(ofSize: 14)
        name.textColor = .black
        return name
    }()
    private let numberCardLabel: UILabel = {
        let number = UILabel()
        number.text = "5018"
        number.font = .systemFont(ofSize: 14)
        number.textColor = .black
        return number
    }()
    private let validDateLabel: UILabel = {
        let valid = UILabel()
        valid.text = "07/22"
        valid.font = .systemFont(ofSize: 14)
        valid.textColor = #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1)
        return valid
    }()
    
    var card: Card? {
        didSet {
            if let numberCard = card?.cardNumber {
                let index = numberCard.index(numberCard.startIndex, offsetBy: 4)
                numberCardLabel.text = String(numberCard[..<index])
                
                if numberCard.starts(with: "3") {
                    iconImage.image = UIImage(named: "amex")
                    nameCardLabel.text = "Amex"
                } else if numberCard.starts(with: "4") {
                    iconImage.image = UIImage(named: "visa")
                    nameCardLabel.text = "Visa"
                } else if numberCard.starts(with: "5") {
                    iconImage.image = UIImage(named: "masterCard")
                    nameCardLabel.text = "MasterCard"
                } else if numberCard.starts(with: "6") {
                    iconImage.image = UIImage(named: "discover")
                    nameCardLabel.text = "Discover"
                } else {
                    iconImage.image = UIImage(named: "credit-card")
                    nameCardLabel.text = "Unknown card"
                }
            }
            if let dateYear = card?.dateYear, let month = card?.dateMonth {
                validDateLabel.text = "\(month)/\(dateYear)"
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addToView()
        setupConstraints()
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    @objc private func removeCard() {
        delegate?.deleteCard(itemCard: card!)
    }
    
    private func addToView() {
        contentView.addSubview(iconImage)
        contentView.addSubview(removeButton)
        contentView.addSubview(validDateLabel)
        contentView.addSubview(cardStackView)
        
        [nameCardLabel, dotIcon, numberCardLabel].forEach { cardStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        iconImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.left.equalToSuperview().inset(15)
            $0.height.width.equalTo(60)
        }
        
        cardStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.left.equalTo(iconImage.snp.right).offset(7)
            $0.height.equalTo(17)
            dotIcon.heightAnchor.constraint(equalToConstant: 4).isActive = true
            dotIcon.widthAnchor.constraint(equalToConstant: 4).isActive = true
        }
        validDateLabel.snp.makeConstraints {
            $0.top.equalTo(cardStackView.snp.bottom).offset(3)
            $0.left.equalTo(iconImage.snp.right).offset(7)
        }
        
        removeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(23.20)
            $0.width.equalTo(17.63)
            $0.height.equalTo(19.13)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
