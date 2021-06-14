//
//  CountrysListViewController.swift
//  FlatStackTestTask
//
//  Created by Сергей Шабельник on 13.06.2021.
//

import UIKit

class CountrysListViewController: UIViewController {
    
    //MARK: - Constants
    enum Constants {
        static let firstPage = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
        static let countryCell = "CountryTableViewCell"
        static let loadingCell = "LoadingTableViewCell"
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private var countries: [Country] =  []
    private var nextPage: String?
    private var refreshControl = UIRefreshControl()
    private var isNetworking = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupRefresher()
        getCountrys(page: Constants.firstPage)
    }
    
    //MARK: - Custom Methods
    private func getCountrys(page: String) {
        NetworkManager.shared.getData(page: page) { result in
            switch result {
            case .failure(let error):
                ErrorPresenter.showError(message: error.localizedDescription, on: self)
            case .success(let response):
                let countries = response.countries
                self.countries += countries
                self.isNetworking = false
                self.nextPage = response.next
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func setupRefresher() {
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func pulledToRefresh() {
        countries.removeAll()
        getCountrys(page: Constants.firstPage)
    }
    
    func scrollViewDidScroll(_ scrollView:UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            
            if !isNetworking && nextPage != "" {
                
                isNetworking = true
                tableView.reloadData()
                getCountrys(page: nextPage!)
            }
        }
    }
}

//MARK: - Table View
extension CountrysListViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let countryNib = UINib(nibName: Constants.countryCell, bundle: nil)
        tableView.register(countryNib, forCellReuseIdentifier: Constants.countryCell)
        
        let loadingNib = UINib(nibName: Constants.loadingCell, bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: Constants.loadingCell)
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return countries.count
        case 1:
            let count = isNetworking ? 1 : 0
            return count
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.countryCell) as! CountryTableViewCell
            cell.configureCell(for: countries[indexPath.row])
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingCell) as! LoadingTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard.countryDetailsViewController()
        viewController.selectedCountry = countries[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
