//
//  ChechButton.swift
//  QrRestaurantMenuApp
//
//  Created by IOS-Developer on 18.06.2021.
//

import UIKit

class CheckBox: UIButton {
    var checked = false {
        didSet {
            if checked == true {
                self.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            }
            else {
                self.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapped() {
        self.checked = !self.checked
        if checked == true {
            self.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }
        else {
            self.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        }
    }
}
