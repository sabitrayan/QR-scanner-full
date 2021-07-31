//
//  TestViewController.swift
//  test_project
//
//  Created by Temirlan Orazkulov on 08.07.2021.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {

    private let viewCell = UIView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Триумф"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Калифорния классическая, Филадельфия лайт, Бостон, Зеленая миля"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "7990 ₸"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var testView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Test"
        view.addSubview(viewCell)
        viewCell.addSubview(testView)
        viewCell.addSubview(nameLabel)
        viewCell.addSubview(priceLabel)
        viewCell.addSubview(descLabel)
        viewCell.addSubview(buttonView)
        setupConstraints()
        viewCell.layer.borderWidth = 2
        viewCell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(animation))
        testView.addGestureRecognizer(gesture)
    }
    
    @objc func animation(){
        let animationOfMove = CABasicAnimation()
        let animation = CABasicAnimation()
        animationOfMove.keyPath = "position.x"
        animationOfMove.duration = 1
        animationOfMove.fromValue = view.bounds.midX - 50
        animationOfMove.toValue = view.bounds.midX - 100
        animation.keyPath = "transform.scale"
        animation.fromValue = 1 // width = 100
        animation.toValue = 3 // width = 200
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animationOfMove.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        testView.layer.add(animation, forKey: "move")
        testView.layer.add(animationOfMove, forKey: "scale")
        testView.layer.transform = CATransform3DMakeScale(3, 3, 1)
        testView.layer.position = CGPoint(x: viewCell.bounds.midX, y: viewCell.bounds.midY - 100/2)
    }
    
    func setupConstraints(){
        viewCell.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(150)
        }
        testView.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(12)
            make.width.equalTo(100)
            make.height.equalTo(70)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.right.equalTo(testView.snp.left).offset(15)
        }
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.equalTo(descLabel.snp.bottom).offset(5)
        }
        buttonView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(testView.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview()
        }
    }

}
