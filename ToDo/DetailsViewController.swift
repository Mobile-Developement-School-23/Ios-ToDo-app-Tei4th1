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
        //view.addSubview(contentView)
        //view.addSubview(stackView)

        scrollView.addSubview(taskTextView)
        taskTextViewSetting()
        navigationbarSetting()
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
        taskTextView.text = "Что надо сделать?"
        taskTextView.textColor = .lightGray
        taskTextView.backgroundColor = .white
        taskTextView.layer.cornerRadius = 10
        taskTextView.isScrollEnabled = false
        
        taskTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
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
        textView.invalidateIntrinsicContentSize()
    }
}

//extension DetailsViewController {
//    private func setupViewsConstraints() {
//        stackView.snp.makeConstraints { make in
//            make.top.equalTo(contentView)
//            make.right.equalTo(contentView)
//            make.left.equalTo(contentView)
//        }
//    }
//}
