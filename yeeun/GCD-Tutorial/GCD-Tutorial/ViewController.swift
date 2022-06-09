//
//  ViewController.swift
//  GCD-Tutorial
//
//  Created by 허예은 on 2022/06/05.
//

import UIKit

let chapters = [1, 2, 3, 4, 5]

class ViewController: UIViewController {
    // MARK: Properties
    private var dataSource: UITableViewDiffableDataSource<Int, UUID>!
    private var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
    
    // MARK: Components
    private lazy var tableView: UITableView = { createTableView() }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initSnapshot()
        
        style()
        layout()
    }
    
    private func initTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        dataSource = UITableViewDiffableDataSource<Int, UUID>(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
            
            return cell
        })
        
        tableView.dataSource = dataSource
    }
    
    private func initSnapshot() {
        snapshot.appendSections([0])
        
        snapshot.appendItems(chapters)
        dataSource.apply(snapshot)
    }

}

extension ViewController {
    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }
}

extension ViewController {
    private func style() {
        view.addSubview(tableView)
    }
    
    private func layout(){
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}


// MARK: Definitions
extension ViewController {
    
}
