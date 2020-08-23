//
//  MainVCViewModel.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/23/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import Foundation

final class MainVCViewModel {
    //Listeners
    var onConfigUpdated: (() -> Void)?
    var onPetsUpdated: (() -> Void)?
    
    //Status Checks
    var networkIsBusy: Bool {return isFetchingPets || isFetchingConfig}
    fileprivate var isFetchingConfig: Bool = false
    fileprivate var isFetchingPets: Bool = false
    
    //Model Variables
    var config: AppConfiguration? = AppConfiguration(workingTime: OpenDayTime(startDay: .monday, endDay: .friday, startTime: 900, endTime: 1800), isChatEnabled: false, isCallEnabled: true)
    var pets: [Pet]? = {
        let jsonData = Data((#"{"image_url": "https://upload.wikimedia.org/wikipedia/commons/0/00/Two_adult_Guinea_Pigs_%28Cavia_porcellus%29.jpg","title": "Guinea Pig","content_url": "https://en.wikipedia.org/wiki/Guinea_pig","date_added": "2018-08-04T10:45:29.027Z"}"#).utf8)
        let decoder = JSONDecoder()
        return [try! decoder.decode(Pet.self, from: jsonData)]
    }()
    
    func fetchConfig() {
        isFetchingConfig = true
        APISession(urlSession: .shared).getData(apiRoute: APIRoutes.getConfig) { [weak self] result in
            self?.isFetchingConfig = false
            switch result {
            case .success(let data):
                do {
                    self?.config = try JSONDecoder().decode(AppConfiguration.self, from: data)
                    self?.onConfigUpdated?()
                } catch {
                    
                }
            case .failure(_):
                return
            }
        }
    }
    
    func fetchPets() {
        isFetchingPets = true
        APISession(urlSession: .shared).getData(apiRoute: APIRoutes.getPets) { [weak self] result in
            self?.isFetchingPets = false
            switch result {
            case .success(let data):
                do {
                    self?.pets = try JSONDecoder().decode([Pet].self, from: data)
                    self?.onPetsUpdated?()
                } catch {
                }
            case .failure(_):
                return
            }
        }
    }
}
