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
    
    func setUpData(viewController: DetailViewController) {
        guard let urlString = picture?.urls?.regular else {
            print("ERROR: No url for passed picture in DetailVC")
            return
        }
        
        if let url = URL(string: urlString) {
            viewController.photoImage.kf.setImage(with: url)
        }
        viewController.likeNumber.text = "\(picture?.likes ?? 0)"
        viewController.titleLabel.text = picture?.description ?? "Missing a cool title"
        viewController.photographerNameLabel.text = picture?.user?.name
        setDate(input: picture?.createdAt ?? "", viewController: viewController)
        guard let value = picture?.isFavorited else {return}
        viewController.favoriteButton.isSelected = value
    }
    
    func buttonCheck(){
        picture?.isFavorited?.toggle()
        
        guard let value = picture?.isFavorited else {
            print("Picture isFavorited propety is nil in DetailViewModel")
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
    
    func setDate(input: String, viewController: DetailViewController){
        var stringDate = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: input) {
            stringDate = date
            
        }
        formatter.dateFormat = "MMM d, yyyy"
        viewController.dateLabel.text = formatter.string(from: stringDate)
     }
    
}
