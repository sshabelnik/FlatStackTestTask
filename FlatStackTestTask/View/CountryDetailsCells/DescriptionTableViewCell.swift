//
//  DescriptionTableViewCell.swift
//  FlatStackTestTask
//
//  Created by Сергей Шабельник on 14.06.2021.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configureCell(with description: String) {
        self.selectionStyle = .none
        
        descriptionLabel.text = description
    }
}
