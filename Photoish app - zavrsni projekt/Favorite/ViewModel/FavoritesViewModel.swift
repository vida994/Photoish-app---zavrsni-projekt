//
//  FavoritesViewModel.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 03.08.2021..
//

import RxSwift
import RxCocoa

protocol FavoritesViewModel {
    
    var favoritedPicture: [Picture] {get set}
    
    
}
