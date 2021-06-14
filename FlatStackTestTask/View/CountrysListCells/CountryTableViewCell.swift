//
//  CountryTableViewCell.swift
//  FlatStackTestTask
//
//  Created by Сергей Шабельник on 13.06.2021.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryCapitalLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configureCell(for country: Country) {
        self.selectionStyle = .none
        
        countryNameLabel.text = country.name
        countryCapitalLabel.text = country.capital
        descriptionLabel.text = country.descriptionSmall
        
        NetworkManager.shared.getFlagImage(by: country.countryInfo.flag) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.flagImageView?.image = UIImage(named: "imagePlaceholder")
            case .success(let image):
                self.flagImageView?.image = image
            }
        }
    }
}
