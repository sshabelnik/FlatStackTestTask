//
//  InfoRowTableViewCell.swift
//  FlatStackTestTask
//
//  Created by Сергей Шабельник on 14.06.2021.
//

import UIKit

class InfoRowTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    func configureCell(image: UIImage, title: String, subTitle: String) {
        self.selectionStyle = .none
        
        mainImage.image = image
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
