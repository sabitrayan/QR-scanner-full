//
//  RestaurantInfoTableViewCell.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 17.06.2021.
//

import UIKit

class RestaurantInfoTableViewCell: UITableViewCell {

    static let identifier = "tableViewCell"
   
    
    var addressText: String? {
        didSet{
            addressLabel.text = addressText
        }
    }
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 14)
        return label
    }()       
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(addressLabel)
        backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        selectionStyle = .none
        addressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
