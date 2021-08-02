//
//  HomeViewModelImpl.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import Foundation
import RxSwift
import RxCocoa


class HomeViewModelImpl: HomeViewModel {
    
    var screenDataRelay = BehaviorRelay<[Picture]>.init(value: [])
    var loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var loadDataSubject = ReplaySubject<()>.create(bufferSize: 1)
    
    private let picturesRepository: PicturesRepository
    
    init(picturesRepository: PicturesRepository) {
        self.picturesRepository = picturesRepository
    }
    
    func initializeViewModelObservables() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(initializeLoadPicturesSubject(subject: loadDataSubject))
        return disposables
    }
}

private extension HomeViewModelImpl {
    
    func initializeLoadPicturesSubject(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .flatMap{ [unowned self] (_) -> Observable<[Picture]?> in
                self.loaderSubject.onNext(true)
                return self.picturesRepository.getPictures()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { (pictureResponse) in
                guard let pictures = pictureResponse else {
                    return
                }
                self.screenDataRelay.accept(pictures)
                self.loaderSubject.onNext(false)
            })
    }
}
