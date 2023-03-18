//
//  AstronomyViewService.swift
//  WaIE
//
//  Created by Anshu Vij on 18/03/23.
//

import Foundation


protocol AstronomyViewServiceDelegate {
    func fetchImageData(completion: @escaping(Result<AstronomyModel, CustomError>) -> Void)
}
protocol AstronomyDataDelegate {
    func getData(completion: @escaping(Result<AstronomyDataViewModel, CustomError>) -> Void)
}

class AstronomyViewService: AstronomyViewServiceDelegate  {
    
    func fetchImageData(completion: @escaping(Result<AstronomyModel, CustomError>) -> Void) {
        guard let url = URL(string: Constants.url) else {
            return completion(.failure(.BadURL))
        }
        NetworkManager().requestData(type: AstronomyModel.self, url: url, completion: completion)
    }
   
}

class OfflineDataHandler: AstronomyDataDelegate {
    
    func getData(completion: @escaping(Result<AstronomyDataViewModel, CustomError>) -> Void) {
        
        if let cachecObject: AstronomyDataViewModel = cacher.load(fileName: Constants.fileName) {
            completion(.success(cachecObject))
       }
        else
        {
            completion(.failure(CustomError.NoData))
        }
    }

}
