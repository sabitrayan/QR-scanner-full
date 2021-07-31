//
//  RestaurantCollectionViewCell.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 4.06.2021.
//

import UIKit
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static var restaurantId = "restaurantId"
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1).cgColor
        return view
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 11.5)
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        return label
    }()
    
    var categoryItem: Category? {
        didSet {
            if let categoryName = categoryItem?.name {
                categoryLabel.text = categoryName
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }
    
    func toColorView(){
        view.backgroundColor = UIColor(red: 0.729, green: 1, blue: 0.941, alpha: 1)
    }
    
    func defaultColorView(){
        view.backgroundColor = .white
    }
    
    private func setupConstraint() {
        contentView.addSubview(view)
        view.addSubview(categoryLabel)
        
        view.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.right.equalTo(view.snp.right)
            $0.left.equalTo(view.snp.left)
            $0.bottom.equalTo(view.snp.bottom)
//            $0.height.equalTo(82)
//            $0.width.equalTo(30)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
