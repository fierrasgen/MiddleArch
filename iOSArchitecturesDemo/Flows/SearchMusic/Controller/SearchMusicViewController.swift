//
//  SearchMusicViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Alexander Novikov on 09.12.2021.
//  Copyright © 2021 ekireev. All rights reserved.
//

import UIKit

class SearchMusicViewController: UIViewController {
    
    private var searchMusicView: SearchMusicView {
        return self.view as! SearchMusicView
    }
    
    var searchResults = [ITunesSong]() {
        didSet {
            searchMusicView.tableView.isHidden = false
            searchMusicView.tableView.reloadData()
            searchMusicView.searchBar.resignFirstResponder()
        }
    }
    
    private let presenter: SearchMusicViewOutput
      
    init(presenter: SearchMusicViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = SearchMusicView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apps", style: .plain, target: self, action: #selector(toAppsTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
        self.searchMusicView.searchBar.delegate = self
        self.searchMusicView.tableView.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseIdentifier)
        self.searchMusicView.tableView.delegate = self
        self.searchMusicView.tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.throbber(show: false)
    }
    
    @objc private func toAppsTapped() {
        presenter.viewDidMoveToAppSearch()
    }
    
    func throbber(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoResults() {
        self.searchMusicView.tableView.isHidden = true
        self.searchMusicView.emptyResultView.isHidden = false
    }
    
    func hideNoResults() {
        self.searchMusicView.emptyResultView.isHidden = true
    }
    
    private func requestMusic(with query: String) {
        presenter.viewDidSearch(with: query)
        self.searchResults = []
        self.searchMusicView.tableView.reloadData()
    }
}

extension SearchMusicViewController: SearchMusicViewInput { }

extension SearchMusicViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: SongCell.reuseIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? SongCell else {
            return dequeuedCell
        }
        let song = self.searchResults[indexPath.row]
        let cellModel = SongCellModelFactory.cellModel(from: song)
        cell.configure(with: cellModel)
        
        return cell
    }
}

extension SearchMusicViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let song = searchResults[indexPath.row]
        presenter.viewDidSelectSong(song)
    }
}

extension SearchMusicViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        if query.count == 0 {
            searchBar.resignFirstResponder()
            return
        }
        self.requestMusic(with: query)
    }
}

