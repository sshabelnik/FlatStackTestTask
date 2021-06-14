//
//  LocalDataManager.swift
//  FlatStackTestTask
//
//  Created by Сергей Шабельник on 13.06.2021.
//

import Foundation
import UIKit

class LocalDataManager {
    static let shared = LocalDataManager()
    
    private var cacheImage = [String:UIImage]()
    
    private let userDefaults = UserDefaults.standard
    private let countriesKey = "countries"
    private let cacheImageKey = "cacheImage"
    
    init() {
        
        if let savedCacheImage = userDefaults.dictionary(forKey: cacheImageKey),
            savedCacheImage is [String : UIImage] {
            
            self.cacheImage = savedCacheImage as! [String : UIImage]
        }
    }
    
    //MARK: - Country methods
    
    func getAllData() -> [Country] {
        
        if let countriesData = userDefaults.object(forKey: countriesKey) as? Data {
            
            if let countries = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(countriesData) as? [Country] {
                
                return countries
            }
        }
        return []
    }
    
    func saveAllData(countries: [Country]) {
        
        let countriesData = try? NSKeyedArchiver.archivedData(withRootObject: countries, requiringSecureCoding: false)
        userDefaults.set(countriesData, forKey: countriesKey)
    }
    
    func getCachedImage(key: String) -> UIImage? {
        
        if let image = cacheImage[key] {
            return image
        }
        return nil
    }
    
    //MARK: - CacheImage methods
    
    func saveCachedImage(image: UIImage, key: String) {
        
        cacheImage[key] = image
    }
    
    func saveCacheImageDictionary() {
        
        userDefaults.set(cacheImage, forKey: cacheImageKey)
    }
    
}
