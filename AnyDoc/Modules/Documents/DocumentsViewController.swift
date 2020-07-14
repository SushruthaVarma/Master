//
//  DocumentsViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/11/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(DocumentTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        return searchController
    }()
    
    // MARK: Constants
    
    enum Constants {
        static let scansSegue = "scansSegue"
        static let collectionInteritemSpacing: CGFloat = 8
        static let collectionLineSpacing: CGFloat = 8
        static let collectionNumberOfColumns: CGFloat = 3
    }
    
    // MARK: Properties
    
    var documents = [Document]() {
        didSet {
            tableView.reloadData()
        }
    }
    

    // MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        addObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Helpers
    
    private func configureNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didAddNewDocumentHandler),
            name: .didAddNewDocument,
            object: nil)
    }
    
    @objc private func didAddNewDocumentHandler(notification: Notification) {
        guard let document = notification.object as? Document else { return }
        documents.append(document)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scanVC = segue.destination as? ScansViewController {
            scanVC.document = sender as? Document
        }
    }
}


// MARK: - UICollectionViewDelegate

extension DocumentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.scansSegue, sender: documents[indexPath.row])
    }
}

// MARK: - UICollectionViewDataSource

extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DocumentTableViewCell.reuseId, for: indexPath)
            as? DocumentTableViewCell else { fatalError() }
        cell.document = documents[indexPath.row]
        return cell
    }
}
