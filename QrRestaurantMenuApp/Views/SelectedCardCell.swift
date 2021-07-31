//
//  SnackBarTableViewCell.swift
//  QrRestaurantMenuApp
//
//  Created by IOS-Developer on 17.06.2021.
//

import UIKit

class SelectedCardCell: UITableViewCell {
    
    static var selectID = "selectID"
    var key: String?
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.cornerRadius = 16 / 2
        return view
    }()
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 10 / 2
        return view
    }()
    private let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let dotIcon: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.cornerRadius = 1
        return view
    }()
    private let cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeDot()
    }
    
    func fillDot() {
        dotView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func removeDot() {
        dotView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func addToView() {
        contentView.addSubview(iconImage)
        contentView.addSubview(validDateLabel)
        contentView.addSubview(cardStackView)
        contentView.addSubview(circleView)
        circleView.addSubview(dotView)
        
        [nameCardLabel, dotIcon, numberCardLabel].forEach { cardStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        circleView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(16)
        }
        dotView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
        iconImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(circleView.snp.right).offset(12)
            $0.width.equalTo(50)
            $0.height.equalTo(35)
        }
        cardStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalTo(iconImage.snp.right).offset(10)
            $0.height.equalTo(20)
            
        }
        dotIcon.snp.makeConstraints {
            $0.bottom.top.equalToSuperview().inset(3)
            $0.width.equalTo(3)
        }
        validDateLabel.snp.makeConstraints {
            $0.top.equalTo(cardStackView.snp.bottom).offset(5)
            $0.left.equalTo(iconImage.snp.right).offset(10)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
