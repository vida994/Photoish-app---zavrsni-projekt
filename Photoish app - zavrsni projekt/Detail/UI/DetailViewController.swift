//
//  DetailViewController.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 30.07.2021..
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let photoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let likeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "Vector1")
        return image
    }()
    
    let likeNumber: UILabel = {
        let number = UILabel()
        number.font = UIFont.systemFont(ofSize: 24)
        number.textColor = .white
        return number
    }()
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        title.numberOfLines = 2
        title.textColor = .white
        return title
    }()
    
    let photographerNameLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18)
        title.textColor = .white
        return title
    }()
    
    let dateLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = .white
        return title
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Vector"), for: .normal)
        button.setImage(UIImage(named: "Vector")?.withTintColor(UIColor(red: 0.996, green: 0.867, blue: 0.745, alpha: 1)), for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let viewModel: DetailViewModel
    
    var indexPathOfSelectedPicture: Int
    
    init(viewModel: HomeViewModel, indexPath: Int) {
        self.indexPathOfSelectedPicture = indexPath
        self.viewModel = DetailViewModelImpl(viewModel: viewModel, indexPath: indexPathOfSelectedPicture)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initializeButtonCheckObservable(subject: viewModel.loadDataFavoritedButtonSubject).disposed(by: disposeBag)
     }
}

private extension DetailViewController {
    
    func configureUI() {
        view.backgroundColor = .mainColor
        view.addSubviews(views: photoImage, likeImage, likeNumber, titleLabel, photographerNameLabel, dateLabel, favoriteButton)
        configureConstraints()
        viewModel.setUpData(viewController: self)
        configureNavigationController()
      }
    
    func configureNavigationController() {
        navigationController?.navigationBar.barTintColor = .mainColor
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPopUp))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPopUp))
        navigationItem.title = viewModel.picture?.user?.name
    
    }
    
    func configureConstraints() {
        
        photoImage.snp.makeConstraints { (maker) in
            maker.width.equalTo(330)
            maker.height.equalTo(380)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        likeImage.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(22)
            maker.top.equalTo(photoImage.snp.bottom).offset(18)
            maker.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        likeNumber.snp.makeConstraints { (maker) in
            maker.top.equalTo(photoImage.snp.bottom).offset(16)
            maker.leading.equalTo(likeImage.snp.trailing).offset(10)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(likeImage.snp.bottom).offset(16)
            maker.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
            maker.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        photographerNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(photographerNameLabel.snp.bottom).offset(3)
            maker.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        favoriteButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(35)
            maker.top.equalTo(photoImage.snp.bottom).offset(16)
            maker.trailing.equalTo(view.safeAreaLayoutGuide).offset(-38)
        }
    }
   
}

private extension DetailViewController {
    
    @objc func favoriteButtonTapped() {
        favoriteButton.isSelected.toggle()
        viewModel.loadDataFavoritedButtonSubject.onNext(viewModel.viewModel?.screenDataRelay.value[indexPathOfSelectedPicture].isFavorited ?? false)
        
    }
    
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
}

private extension DetailViewController {
    
    func initializeButtonCheckObservable(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (status) in
                viewModel.buttonCheck()
            })
    }
    
}
