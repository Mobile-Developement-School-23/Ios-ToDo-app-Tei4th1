//
//  ViewController.swift
//  ToDo
//
//  Created by Zhdan Pavlov on 23.06.2023.
//

import UIKit
import SnapKit

class TodoViewController: UIViewController {
    var itemsTableView = UITableView()
    var itemsCache = FileCache()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeView()
        settingAddButton()
        
        itemsTableView = UITableView(frame: view.bounds, style: .plain)
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        view.addSubview(itemsTableView)
        itemsTableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(150)
            maker.left.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(20)
            maker.right.equalToSuperview().inset(10)
        }
        itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        
        settingAddButton()
    }
    
    func initializeView() {
        view.backgroundColor = UIColor(red: 247/255, green: 246/255, blue: 242/255, alpha: 1)
    }
    
}
extension TodoViewController: UITableViewDataSource {
    

    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCache.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(UITableViewCell.self)",
            for: indexPath)
        let cellRow = indexPath.row
        var сellСonfiguration = cell.defaultContentConfiguration()
        сellСonfiguration.text = itemsCache.items[cellRow].text
        cell.contentConfiguration = сellСonfiguration
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
}

extension TodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskDone = UIContextualAction(style: .normal,
                                          title: "") { [weak self] (action, view, taskDone) in
            self?.itemsCache.items[indexPath.row].taskDone
            taskDone(true)
        }
        taskDone.image = UIImage(named: "taskDone")
        taskDone.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [taskDone])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let moveToTrash = UIContextualAction(style: .destructive,
                                             title: "") { [weak self] (action, view, taskDone) in
            self?.itemsCache.items[indexPath.row].taskDone
            taskDone(true)
        }
        moveToTrash.image = UIImage(named: "Trash")
        moveToTrash.backgroundColor = .systemRed
        
        let info = UIContextualAction(style: .normal,
                                      title: "Archive") { [weak self] (action, view, taskDone) in
            self?.itemsCache.items[indexPath.row].taskDone
            taskDone(true)
        }
        info.image = UIImage(named: "info")
        info.backgroundColor = .systemGray
        
        return UISwipeActionsConfiguration(actions: [moveToTrash, info])
    }
}
extension TodoViewController {
    func settingAddButton() {
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "Remove"), for: .normal)
        addButton.addTarget(self, action: #selector(openDetailsViewController), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(714)
            
        }
    }
    @objc func openDetailsViewController() {
        let detailsViewController = DetailsViewController()
        detailsViewController.modalPresentationStyle = .formSheet
        let navidationController = UINavigationController(rootViewController: detailsViewController)
        self.present(navidationController, animated: true, completion: nil)
    }
    
}

class details: UIView {
    
}
