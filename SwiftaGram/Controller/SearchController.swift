//
//  SearchController.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit

private let idenTifier = "searchedUserCell"

class SearchController: UITableViewController {
    
    //MARK: - Properties
    private var filteredUsers = [User]()
    private var users = [User]()
    private var Searching: Bool {
        return searchCont.isActive && !searchCont.searchBar.text!.isEmpty
    }
    private let searchCont = UISearchController(searchResultsController: nil)
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        configureUI()
        fetchUsers()
        
        
    }
    
    //MARK: - API
    func fetchUsers(){
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        tableView.rowHeight = 65
        tableView.register(SearchedUserCell.self, forCellReuseIdentifier: idenTifier)
    }
    
    func setUpSearchController() {
        searchCont.searchResultsUpdater = self
        searchCont.obscuresBackgroundDuringPresentation = false
        searchCont.hidesNavigationBarDuringPresentation = false
        searchCont.searchBar.placeholder = "Search"
        navigationItem.searchController = searchCont
        definesPresentationContext = false
    }
}

//MARK: - DataSource
extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Searching ? filteredUsers.count : users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idenTifier,for: indexPath) as! SearchedUserCell
        let user  = Searching ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.ViewModel = ProfileCellViewModel(user: user)
        return cell
    }
//MARK: -  Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user  = Searching ? filteredUsers[indexPath.row] : users[indexPath.row]
        let vc = UserProfileController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: -  Search Updating
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({$0.username.contains(searchText)  || $0.name.lowercased().contains(searchText)})
        self.tableView.reloadData()
    }
    
}


