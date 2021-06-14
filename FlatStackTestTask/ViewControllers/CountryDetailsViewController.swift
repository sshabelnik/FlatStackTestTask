//
//  CountryDetailsViewController.swift
//  FlatStackTestTask
//
//  Created by Сергей Шабельник on 13.06.2021.
//

import UIKit

class CountryDetailsViewController: UIViewController {
    
    
    //MARK: - Constants
    enum Constants {
        static let infoRowCell = "InfoRowTableViewCell"
        static let descriptionCell = "DescriptionTableViewCell"
        static let imageCell = "ImageSliderCollectionViewCell"
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Propeties
    var selectedCountry: Country!
    private var flagImage: UIImage!
    private var images: [UIImage] = []

    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configurePageControl()
        configureTableView()
        fetchImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        enableNavBarTransparency()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        disableNavBarTransparency()
    }
    
    
    //MARK: -
    private func fetchImages() {
        
        images = [UIImage(named: "imagePlaceholder")!] //Adding PlaceHolder
        
        let flagImageURL = selectedCountry.countryInfo.flag
        var imagesURL = selectedCountry.countryInfo.images
        if !selectedCountry.image.isEmpty {
            imagesURL.append(selectedCountry.image)
        }
        
        NetworkManager.shared.getImages(flagImageURL: flagImageURL, imageURLs: imagesURL) { result in
            
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let images):
                DispatchQueue.main.async {
                    
                    self.images.removeAll() //Removing PlaceHolder
                    self.images = images
                    self.pageControl.numberOfPages = images.count
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func configurePageControl() {
        
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
    }
    
    private func enableNavBarTransparency() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func disableNavBarTransparency() {
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.tintColor = .black
    }
}

//MARK: - CollectionView Stack

extension CountryDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cellNib = UINib(nibName: Constants.imageCell, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: Constants.imageCell)
        
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCell, for: indexPath) as! ImageSliderCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(collectionView.contentOffset.x) / Int(self.collectionView.frame.width)
    }
    
    //MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

//MARK: - Table View Stack
extension CountryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let infoRowNib = UINib(nibName: Constants.infoRowCell, bundle: nil)
        tableView.register(infoRowNib, forCellReuseIdentifier: Constants.infoRowCell)
        
        let descriptionNib = UINib(nibName: Constants.descriptionCell, bundle: nil)
        tableView.register(descriptionNib, forCellReuseIdentifier: Constants.descriptionCell)
        
        //HeaderView with label
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 75)
        
        let label = UILabel()
        label.text = selectedCountry.name
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.numberOfLines = 0
        
        headerView.addSubview(label)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()

        //Label constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 25).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 7).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.infoRowCell) as! InfoRowTableViewCell
            switch indexPath.row {
            case 0:
                cell.configureCell(image: UIImage(named: "starIcon")!, title: "Capital", subTitle: selectedCountry.capital)
            case 1:
                cell.configureCell(image: UIImage(named: "faceIcon")!, title: "Population", subTitle: String(selectedCountry.population))
            case 2:
                cell.configureCell(image: UIImage(named: "earthIcon")!, title: "Continent", subTitle: selectedCountry.continent)
            default:
                return UITableViewCell()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.descriptionCell) as! DescriptionTableViewCell
            cell.configureCell(with: selectedCountry.countryDescription)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0: return 45
        default: return UITableView.automaticDimension
        }
    }
    
}
