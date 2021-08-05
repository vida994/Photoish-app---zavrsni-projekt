//
//  DetailViewModel.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 30.07.2021..
//

import UIKit
import RxSwift
import RxCocoa

protocol DetailViewModel: class {
    
    var viewModel: HomeViewModel? {get set}
    
    
    var picture: Picture? {get set}
    
    var indexPathOfSelectedPicture: Int? {get set}
   
    var loadDataFavoritedButtonSubject: ReplaySubject<Bool> {get}
    
    func buttonCheck()
    
    func setUpData(viewController: DetailViewController)
    
}
