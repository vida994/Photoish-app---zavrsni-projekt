//
//  DetailViewModelImpl.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 30.07.2021..
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewModelImpl: DetailViewModel {
 
    var viewModel: HomeViewModel?
    
    var picture: Picture?
    
    var indexPathOfSelectedPicture: Int?
    
    var loadDataFavoritedButtonSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    
    init(viewModel: HomeViewModel, indexPath: Int) {
        self.viewModel = viewModel
        self.indexPathOfSelectedPicture = indexPath
        self.picture = viewModel.screenDataRelay.value[indexPath]
        if picture?.isFavorited == nil {
            picture?.isFavorited = false
        }
    }
  
    
    func buttonCheck(){
        picture?.isFavorited?.toggle()
        
        guard let value = picture?.isFavorited else {
            return
        }
        
        if value {
            var pictures = viewModel?.screenDataRelay.value
            pictures?[indexPathOfSelectedPicture!].isFavorited = picture?.isFavorited
            self.viewModel?.screenDataRelay.accept(pictures!)
        }
        
        else {
            var pictures = viewModel?.screenDataRelay.value
            pictures?[indexPathOfSelectedPicture!].isFavorited = picture?.isFavorited
            self.viewModel?.screenDataRelay.accept(pictures!)
        }
        
        
        
    }
    
    
}
