//
//  MenuTableViewCell.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 03.06.2021.
//

import UIKit
import Firebase
import SnapKit


protocol MenuTableViewCellDelegate: AnyObject {
    func plusButtonTapped(menuItem: MenuItem, count: Int)
    func minusButtonTapped(menuItem: MenuItem, count: Int)
}

class MenuTableViewCell: UITableViewCell {
    static let identifier = "productCell"
    
    var count = 0 {
        didSet {
            countLabel.text = "\(count)"
        }
    }
    weak var delegate: MenuTableViewCellDelegate?
    
    var menuItem: MenuItem? {
        didSet {
            if let image = menuItem?.imageUrl {
                downloadImage(from: URL(string: image))
            }
            if let name = menuItem?.name {
                nameLabel.text = name
            }
            if let price = menuItem?.price {
                priceLabel.text = String(price) + " \u{20B8}"
            }
            if let description = menuItem?.description {
                descriptionLabel.text = description
            }
        }
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 3
        return view
    }()
    
    let spaceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 14)
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 11.5)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    let menuImageView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    let countView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1).cgColor
        return view
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addTarget(self, action: #selector(plusCount), for: .touchUpInside)
        return button
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 11.5)
        label.textAlignment = .center
        label.text = "0"
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        return label
    }()
    
    lazy var minusButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "minus"), for: .normal)
        button.addTarget(self, action: #selector(minusCount), for: .touchUpInside)
        return button
    }()
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none
        backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        setupConstraints()
        contentView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        imageView?.frame = CGRect(x: 20, y: 80, width: 100, height: 100)
    }
    
    private func setupViews(){
        contentView.addSubview(spaceView)
        contentView.addSubview(cellView)
        cellView.addSubview(countView)
        cellView.addSubview(nameLabel)
        cellView.addSubview(descriptionLabel)
        cellView.addSubview(menuImageView)
        cellView.addSubview(priceLabel)
        [minusButton, countLabel, plusButton].forEach{
            countView.addSubview($0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countView.backgroundColor = .white
        countView.layer.borderWidth = 0.5
        count = 0
    }
    
    func animation(){
        let animation = CABasicAnimation()
        animation.keyPath = "transform.scale"
        animation.fromValue = 1
        animation.toValue = 2
        animation.duration = 0.5
        imageView?.layer.add(animation, forKey: "basic")
        imageView?.layer.transform = CATransform3DMakeScale(2, 2, 1)
    }
    
    @objc private func plusCount() {
        delegate?.plusButtonTapped(menuItem: menuItem!, count: count)
        if count == 0 {
            countView.backgroundColor = UIColor(red: 0.729, green: 1, blue: 0.941, alpha: 1)
        }
        count += 1
    }
    @objc private func minusCount() {
        delegate?.minusButtonTapped(menuItem: menuItem!, count: count)
        if count > 0 {
            count -= 1
            if count == 0 {
                countView.backgroundColor = .white
            }
        }
    }
    
    func setColorButton(){
        countView.backgroundColor = UIColor(red: 0.729, green: 1, blue: 0.941, alpha: 1)
        countView.layer.borderWidth = 0
    }
    
    func downloadImage(from url: URL?) {        
        guard let url = url else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // always update the UI from the main thread
            DispatchQueue.main.async { [weak self] in
                self?.menuImageView.image = UIImage(data: data)
            }
        }
    }
    
    func setupConstraints(){
        nameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(10)
            make.height.equalTo(17)
        }
        menuImageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
            make.width.equalTo(101)
            make.height.equalTo(68)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(51)
            make.width.equalTo(200)
        }
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.height.equalTo(21)
        }
        countView.snp.makeConstraints { make in
            make.top.equalTo(menuImageView.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(12)
            make.height.equalTo(30)
            make.width.equalTo(97)
            make.bottom.equalToSuperview().inset(20)
        }
        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
            make.left.equalToSuperview().inset(13)
        }
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
            make.right.equalToSuperview().inset(13)
        }
        countLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        spaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
        cellView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(10)
            make.bottom.equalTo(spaceView.snp.top)
        }
        
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
