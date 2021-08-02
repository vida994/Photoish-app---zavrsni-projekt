//
//  PicturesRepository.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import Foundation
import RxSwift

class PicturesRepositoryImpl: PicturesRepository {
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getPictures() -> Observable<[Picture]?> {
        let pictureResponseObservable: Observable<[Picture]?> = networkManager.getData(from: "https://api.unsplash.com/photos")
        return pictureResponseObservable
    }
}

protocol PicturesRepository: class {
    func getPictures() -> Observable<[Picture]?>
}
