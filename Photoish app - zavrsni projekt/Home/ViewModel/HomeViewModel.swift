//
//  HomeViewModel.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModel {
    var screenDataRelay: BehaviorRelay<[Picture]> {get}
    var loaderSubject: ReplaySubject<Bool> {get}
    var loadDataSubject: ReplaySubject<()> {get}
    
    func initializeViewModelObservables() -> [Disposable]
}
