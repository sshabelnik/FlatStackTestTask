//
//  StoryboardExtension.swift
//  FlatStackTestTask
//
//  Created by Сергей Шабельник on 14.06.2021.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    private static func mainStoryboad() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: nil)}
    
    static func countryDetailsViewController() -> CountryDetailsViewController {
        return mainStoryboad().instantiateViewController(withIdentifier: "CountryDetailsViewController") as! CountryDetailsViewController
    }
}
