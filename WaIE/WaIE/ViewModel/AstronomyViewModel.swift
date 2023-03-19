//
//  AstronomyViewModel.swift
//  WaIE
//
//  Created by Anshu Vij on 18/03/23.
//

import Foundation
protocol AstronomyProtocol {
    func requestTodayImages(isOnlineMode : Bool)
}

class AstronomyViewModel: AstronomyProtocol {
    
    var reloadOnData : (() -> Void)?
    var networkOffline: ((CustomError) -> Void)?
    var astronomyDataViewModel: AstronomyDataViewModel?
    let cacher: OfflineCacher = OfflineCacher(destination: .temporary)
    
    let serviceHandler: AstronomyViewServiceDelegate
    let databaseHandler: AstronomyDataDelegate
    
    init(serviceHandler: AstronomyViewServiceDelegate = AstronomyViewService(),
         databaseHandler: AstronomyDataDelegate = OfflineDataHandler()) {
        self.serviceHandler = serviceHandler
        self.databaseHandler = databaseHandler
    }
    
    func requestTodayImages(isOnlineMode : Bool) {
        
        if isOnlineMode == true {
            serviceHandler.fetchImageData { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.astronomyDataViewModel = AstronomyDataViewModel(explanation: response.explanation, title: response.title, url: response.url)
                    if let astronomyDataViewModel = self.astronomyDataViewModel {
                        FileManager.default.clearTmpDirectory()
                        self.cacher.persist(item: astronomyDataViewModel) { url, error in
                            if let error = error {
                                print("data failed to persist with error: \(error)")
                            } else {
                                print("data persisted in \(String(describing: url))")
                            }
                        }
                    }
                    self.reloadOnData?()
                case .failure (_):
                    self.networkOffline?(.NoData)
                }
            }
        }
            else
            {
                databaseHandler.getData { [weak self] result  in
                    switch result {
                    case .success(let responseData) :
                        self?.astronomyDataViewModel = responseData
                        self?.reloadOnData?()
                        
                    case .failure(_) :
                        self?.networkOffline?(.Offline)
                    }
                }
            }
    }
}
