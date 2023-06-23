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
        
        return cell
    }
}

extension TodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, taskDone) in
                                        self?.itemsCache.items[indexPath.row].taskDone
                                            taskDone(true)
        }
        action.image = UIImage(contentsOfFile: "Prop=off")
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let info = UIContextualAction(style: .normal,
//                                         title: "Archive") { [weak self] (action, view, completionHandler) in
//                                            self?.handleMoveToArchive()
//                                            completionHandler(true)
//        }
//        archive.backgroundColor = .systemGreen
//
//        // Trash action
//        let trash = UIContextualAction(style: .destructive,
//                                       title: "Trash") { [weak self] (action, view, completionHandler) in
//                                        self?.handleMoveToTrash()
//                                        completionHandler(true)
//        }
//        trash.backgroundColor = .systemRed
//
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            itemsCache.removeItem(id: itemsCache.items[indexPath.row].id)
//        }
//    }
}
