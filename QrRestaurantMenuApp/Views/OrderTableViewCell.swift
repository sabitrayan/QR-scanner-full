//
//  OrderTableViewCell.swift
//  QrRestaurantMenuApp
//
//  Created by ryan on 6/20/21.
//
import UIKit
import SnapKit

class OrderTableViewCell: UITableViewCell {
    static var identifier = "1"
    
    var orderItem: OrderItem? {
        didSet {
            guard let url = orderItem?.imageUrl else {return}
            downloadImage(from: URL(string: url))
            orderName.text = orderItem?.name
            orderDesc.text = orderItem?.description
            guard let price = orderItem?.price else {return}
            orderPrice.text = "\(price) \u{20B8}"
            guard let count = orderItem?.count else {return}
            if count > 1 {
                orderCount.text = "\(count) x"
            }
        }
    }
    
    private let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let orderImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let orderName: UILabel = {
        let label = UILabel()
        label.text = "Триумф"
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 14)
        return label
    }()

    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        return view
    }()
    
    private let orderDesc: UILabel = {
        let label = UILabel()
        label.text = "Калифорния классическая, Филадельфия лайт, Бостон, Зеленая миля"
        label.textColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 11.5)
        label.numberOfLines = 0
        return label
    }()

    private let orderPrice: UILabel = {
        let label = UILabel()
        label.text = "\(11980) \u{20B8}"
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 14)
        return label
    }()

    private let orderCount: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.102, green: 0.667, blue: 0.545, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImage(from url: URL?) {
        print("Download Started")
       guard let url = url else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
           print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
    
            DispatchQueue.main.async() { [weak self] in
                guard let image = UIImage(data: data) else {return}
                self?.orderImage.image = image
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
       }

    private func setupConstraints() {
        contentView.addSubview(borderView)
        contentView.addSubview(cellView)
        cellView.addSubview(orderImage)
        cellView.addSubview(orderName)
        cellView.addSubview(orderPrice)
        cellView.addSubview(orderDesc)
        cellView.addSubview(orderCount)
        borderView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(10)
            make.bottom.equalToSuperview()
        }
        cellView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview()
            make.bottom.equalTo(borderView.snp.top)
        }
        orderName.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
        }
        orderImage.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(12)
            make.height.equalTo(68)
            make.width.equalTo(101)
        }
        orderDesc.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.equalTo(orderName.snp.bottom).offset(4)
            make.width.equalTo(185)
        }
        orderCount.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(12)
            make.top.equalTo(orderDesc.snp.bottom).offset(10)
        }
        orderPrice.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.equalTo(orderCount.snp.right).offset(5)
            make.top.equalTo(orderDesc.snp.bottom).offset(10)
        }
    }
}
