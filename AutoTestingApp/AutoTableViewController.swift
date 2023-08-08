//
//  ViewController.swift
//  AutoTestingApp
//
//  Created by Stepan Ostapenko on 06.08.2023.
//

import CoreData
import UIKit
import SnapKit

class AutoTableViewController: UIViewController {

    var fetchController: NSFetchedResultsController<Auto>?
    let cacheService = CacheService()
    let tableView = UITableView()
    let fetchRequest = Auto.fetchRequest()
    var sortButton: UIBarButtonItem!
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        configSearchController()
        fetchController?.delegate = self
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
        configFetchController()
        
    }
    
    func configFetchController() {
        fetchController = cacheService.getFetchResultsController(request: fetchRequest)
        do {
            try fetchController!.performFetch()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

    func setConstraints() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        tableView.dataSource = self
        tableView.delegate = self
        
        sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.to.line"), style: .plain, target: self, action: #selector(sortDescending))
        navigationItem.leftBarButtonItem = sortButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewAuto))
        
    }
    
    @objc func sortAscending() {
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
        sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.to.line"), style: .plain, target: self, action: #selector(sortDescending))
        navigationItem.leftBarButtonItem = sortButton
        configFetchController()
    }
    
    @objc func sortDescending() {
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "price", ascending: false)]
        sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line"), style: .plain, target: self, action: #selector(sortAscending))
        navigationItem.leftBarButtonItem = sortButton
        configFetchController()
    }
    
    @objc func addNewAuto() {
        let viewModel = AutoInfoViewModel(cacheService: cacheService, auto: nil)
        let view = AutoInfoView(viewModel: viewModel)
        navigationController?.pushViewController(view, animated: true)

    }
    
    func configureCell(cell: UITableViewCell, withObject auto: Auto) {
        cell.textLabel?.text = auto.mark ?? ""
        cell.detailTextLabel?.text = auto.distributor ?? "-1"
    }
    
    func configSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск по марке и модели"
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
}


// MARK: - UITableViewDataSource

extension AutoTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        let product = (fetchController?.object(at: indexPath))!
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil { cell = UITableViewCell(style: .value1, reuseIdentifier: identifier) }
        configureCell(cell: cell!, withObject: product)
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = fetchController?.sections else { return 0 }
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchController?.sections else { return nil }
        return sections[section].indexTitle ?? ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }
}

extension AutoTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = (fetchController?.object(at: indexPath))!
        let vc = AutoInfoView(viewModel: AutoInfoViewModel(cacheService: cacheService, auto: product))
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension AutoTableViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            break
        case .update:
            if let indexPath = indexPath {
                let product = fetchController?.object(at: indexPath)
                guard let cell = tableView.cellForRow(at: indexPath) else { break }
                configureCell(cell: cell, withObject: product!)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension AutoTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let term = searchController.searchBar.text, !term.isEmpty {
            let predicate = NSPredicate(format: "mark LIKE %@", argumentArray: ["*\(term)*"])
            fetchRequest.predicate = predicate
            configFetchController()
        } else {
            fetchRequest.predicate = nil
            configFetchController()
        }
    }
}
