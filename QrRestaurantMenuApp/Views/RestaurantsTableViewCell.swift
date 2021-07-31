//
//  RestaurantsTableViewCell.swift
//  QRRestarantMenuApp
//
//  Created by Алишер Батыр on 06.06.2021.
//

import UIKit
import Firebase
import SnapKit


class RestaurantsTableViewCell: UITableViewCell {

    static let identifire = "productCell"
    
//    private let bgView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 20
//        return view
//    }()
    
    private let restImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let restNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-SemiBold", size: 17.5)
        return label
    }()
    
    var restItem: Restaurant? {
        didSet {
            guard let restItem = restItem else {return}
            if let image = restItem.rest_image_url {
                downloadImage(from: URL(string: image))
            }
            
            if let restName = restItem.rest_name {
                restNameLabel.text = restName
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImage(from url: URL?) {
        print("Download Started")
        guard let url = url else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.restImage.image = UIImage(data: data)
                self?.restImage.layer.cornerRadius = 10
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func setupConstraints(){
        contentView.addSubview(restImage)
        contentView.addSubview(restNameLabel)
    
        restImage.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(10)
            make.width.equalTo(355)
            make.height.equalTo(150)
        }
        restNameLabel.snp.makeConstraints { make in
            make.top.equalTo(restImage.snp.bottom).offset(7)
            make.left.equalToSuperview().inset(10)
        }
    }
}
