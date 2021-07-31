//
//  TabBarTitleView.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 26.06.2021.
//

import UIKit

class TabBarTitleView: UIStackView {

    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    var subTitle: String = "" {
        didSet {
            subTitleLabel.text = subTitle
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 17)
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 11)        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spacing = 2
        axis = .vertical
        alignment = .center
        addArrangedSubview(titleLabel)
        addArrangedSubview(subTitleLabel)

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
