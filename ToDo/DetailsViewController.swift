//
//  DetailsViewController.swift
//  ToDo
//
//  Created by Zhdan Pavlov on 28.06.2023.
//

import UIKit
import SnapKit
import CocoaLumberjackSwift

class DetailsViewController: UIViewController, UITextViewDelegate {
    
    var textViewHeight: CGFloat = 120
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(red: 247/255, green: 246/255, blue: 242/255, alpha: 1)
        scrollView.contentSize = contenSize
        scrollView.frame = view.bounds
        return scrollView
    }()
    
    private var contenSize: CGSize {
        CGSize(width: view.frame.width, height: .infinity)
    }
    
    let taskTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        var removeButton = UIButton()
        removeButton.setTitle("Удалить", for: .normal)
        removeButton.titleLabel?.textAlignment = .center
        removeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        removeButton.backgroundColor = .white
        removeButton.setTitleColor(.red, for: .normal)
        removeButton.setTitleColor(.lightGray, for: .disabled)
        removeButton.layer.cornerRadius = 12
        scrollView.addSubview(removeButton)
        scrollView.addSubview(taskTextView)
        taskTextViewSetting()
        navigationbarSetting()
        removeButtonConstraint(button: removeButton)
        
    }
    
    func navigationbarSetting() {
        let buttonBack = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(backButtomTapped))
        self.navigationItem.leftBarButtonItem = buttonBack
        
        let buttonSave = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtomTapped))
        self.navigationItem.rightBarButtonItem = buttonSave
        
        let labelTask = UILabel()
        labelTask.text = "Дело"
        labelTask.textColor = .black
        labelTask.sizeToFit()
        self.navigationItem.titleView = labelTask
    }
    
    @objc func backButtomTapped() {
        dismiss(animated: true)
    }
    @objc func saveButtomTapped() {
        
    }
    
    func taskTextViewSetting() {
        taskTextView.delegate = self
        taskTextView.font = UIFont.systemFont(ofSize: 18)
        taskTextView.text = "Что надо сделать?"
        taskTextView.textColor = .lightGray
        taskTextView.backgroundColor = .white
        taskTextView.layer.cornerRadius = 10
        taskTextView.isScrollEnabled = false
        taskTextView.sizeToFit()
        
        taskTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(16)
            make.width.equalTo(343)
        }
    }
    lazy var textViewHeightConstraint = taskTextView.heightAnchor.constraint(equalToConstant: textViewHeight)
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if taskTextView.textColor == .lightGray {
            taskTextView.text = ""
            taskTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if taskTextView.text == "" {
            
            taskTextView.text = "Что надо сделать?."
            taskTextView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        let minHeight: CGFloat = 120
        
        textViewHeightConstraint.constant = max(contentSize.height, minHeight)
        
        let isTextViewEmpty = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        navigationItem.rightBarButtonItem?.isEnabled = !isTextViewEmpty
        //removeButton.isEnabled = !isTextViewEmpty
        
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    func removeButtonConstraint( button: UIButton) {
        button.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.top.equalTo(taskTextView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
    }
}
