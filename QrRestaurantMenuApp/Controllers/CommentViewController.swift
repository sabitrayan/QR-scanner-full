//
//  CommentViewController.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 27.06.2021.
//

import UIKit

class CommentViewController: UIViewController {

    var text: String? {
        didSet {
            textView.text = text
        }
    }
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Bold", size: 21.88)
        label.text = "Комментарий"
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CloseButton"), for: .normal)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1).cgColor
        textView.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        textView.font = UIFont(name: "Inter-Regular", size: 14)
        textView.text = "Напишите комментарии к заказу..."        
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 0.729, green: 1, blue: 0.941, alpha: 1)
        button.setTitle("Отправить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 17.5)
        button.setTitleColor(UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textView.delegate = self
        self.addDoneButtonOnKeyboard()
        view.addSubview(commentLabel)
        view.addSubview(closeButton)
        view.addSubview(textView)
        view.addSubview(sendButton)
        setupConstraints()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textView.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        textView.resignFirstResponder()
    }
    
    @objc func cancelTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendButtonAction(){
        
    }
    
    func setupConstraints(){
        commentLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(20)
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.right.equalToSuperview().inset(24.3)
            make.width.height.equalTo(15)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(106)
        }
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}

extension CommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Напишите комментарии к заказу..."
            sendButton.alpha = 0.5
            sendButton.isEnabled = false
        }else{
            sendButton.alpha = 1
            sendButton.isEnabled = true
        }
    }
}
