//
//  RestScrollViewController.swift
//  QRRestarantMenuApp
//
//  Created by Алишер Батыр on 14.06.2021.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseDatabase



class RestScrollViewController: UIViewController, UIScrollViewDelegate {
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.text = "Luckee Yu - здесь должно быть какое-то описание. Например, какая кухня или как тут вкусно и красиво. Пока."
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Адреса:"
        label.textColor = .black
        return label
    }()
    let locFirstLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.text = "Наурызбай батыра, 50"
        label.textColor = .black
        return label
    }()
    let locSecondLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.text = "Абылай хана, 175"
        label.textColor = .black
        return label
    }()
    
    let scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:375,height: 300))
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
   
        var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
        var pageControl : UIPageControl = UIPageControl(frame: CGRect(x:80,y: 290, width:200, height:50))
    

        override func viewDidLoad() {
            super.viewDidLoad()
            configurePageControl()
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
            setupViews()
            setupConstraints()

            self.view.addSubview(scrollView)
            for index in 0..<4 {

                frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
                frame.size = self.scrollView.frame.size

                let subView = UIView(frame: frame)
                subView.backgroundColor = colors[index]
                self.scrollView .addSubview(subView)
            }

            self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 4,height: self.scrollView.frame.size.height)
           //pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)

        }
    
    @objc func changePage(){
       
    }
    

        func configurePageControl() {
            // The total number of pages that are available is based on how many available colors we have.
            self.pageControl.numberOfPages = colors.count
            self.pageControl.currentPage = 0
            self.pageControl.tintColor = UIColor.red
            self.pageControl.pageIndicatorTintColor = UIColor.white
            self.pageControl.currentPageIndicatorTintColor = UIColor.red
            self.view.addSubview(pageControl)

        }

        // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
        func changePage(sender: AnyObject) -> () {
            let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
            scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }

    
    func setupViews(){
     
        view.addSubview(descLabel)
        view.addSubview(addressLabel)
        view.addSubview(locFirstLabel)
        view.addSubview(locSecondLabel)
    }
    func setupConstraints(){
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-60)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
        locFirstLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-20)
        }
        locSecondLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-20)
        }
    
    
    }
    
}
    
    
    
    

