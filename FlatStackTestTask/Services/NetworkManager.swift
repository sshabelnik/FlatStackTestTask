//
//  NetworkManager.swift
//  FlatStackTestTask
//
//  Created by Сергей Шабельник on 13.06.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let localDataManager = LocalDataManager.shared
    
    func getData(page: String, completion: @escaping (Result<ResponseModel, Error>) -> Void) {
        
        AF.request(page).responseJSON { response in
            
            if let error = response.error {
                completion(.failure(error))
            }
            
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            if let countries = try? decoder.decode(ResponseModel.self, from: data){
                DispatchQueue.main.async {
                    completion(.success(countries))
                }
            }

        }
    }
    
    func getFlagImage(by stringURL: String, completion: @escaping(Result<UIImage, Error>) -> Void) {
        if let image = localDataManager.getCachedImage(key: stringURL) {
            completion(.success(image))
        }
        
        else {
            AF.request(stringURL).responseData { response in
                if let error = response.error {
                    completion(.failure(error))
                }
                
                guard let data = response.data else { return }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                }
            }
        }
    }
    
    func getImages(flagImageURL: String, imageURLs: [String], complition: @escaping (Result<[UIImage], Error>) -> Void) {
        
        let group = DispatchGroup()
        var images: [UIImage] = []
        
        for imageURL in imageURLs {
            
            if let image = localDataManager.getCachedImage(key: imageURL) {
                
                images.append(image)
                
            } else {
            
                group.enter()
                
                AF.request(imageURL).responseData { response in
                    
                    if let data = response.data{
                        
                        if let image = UIImage(data: data) {
                            
                            self.localDataManager.saveCachedImage(image: image, key: imageURL)
                            images.append(image)
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            
            //Happens after imageURLs loop
            
            if images.isEmpty {
                
                if let image = self.localDataManager.getCachedImage(key: flagImageURL) {
                    
                    DispatchQueue.main.async {
                        complition(.success([image]))
                        return
                    }
                    
                } else {
                
                    self.getFlagImage(by: flagImageURL) { result in
                        switch result {
                        case .failure(let error):
                            complition(.failure(error))
                        case .success(let image):
                            complition(.success([image]))
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    complition(.success(images))
                }
            }
        }
    }
}
