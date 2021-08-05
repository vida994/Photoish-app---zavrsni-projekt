//
//  FavoritesViewController.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 03.08.2021..
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class FavoritesViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 0, right: 3)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let placholderText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Oh no! There is no liked photo. Let's explore now!"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpCollectionView()
        initializeVM()
    }
    
    var viewModel: FavoritesViewModel
    
    let homeViewModel: HomeViewModel
    
    init(viewModel: FavoritesViewModel, homeViewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
        title = "Favorite Photos"
        tabBarItem.image = UIImage(systemName: "square.grid.2x2")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension FavoritesViewController {
    
    func configureUI() {
        view.backgroundColor = UIColor(red: 0.196, green: 0.193, blue: 0.193, alpha: 1)
        tabBarController?.tabBar.barTintColor = UIColor(red: 0.114, green: 0.114, blue: 0.114, alpha: 0.94)
        view.addSubview(placholderText)
     }
    
    func setUpCollectionView() {
        registerCells()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        setUpConstraint()
        }
    
    func registerCells() {
        collectionView.register(FavoritePhotoCollectionViewCell.self, forCellWithReuseIdentifier: FavoritePhotoCollectionViewCell.reuseID)
    }
    
    func setUpConstraint() {
        collectionView.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        placholderText.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalTo(view.frame.size.width/2)
        }
    }
    
    func checkForFavoritePhotos() {
        
        if !viewModel.favoritedPicture.isEmpty {
            placholderText.isHidden = true
            
        }
        else {
            placholderText.isHidden = false
        }
    }
    
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoritedPicture.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritePhotoCollectionViewCell.reuseID, for: indexPath) as? FavoritePhotoCollectionViewCell else {
            print("failed to dequeue the cell in Favorites View Controller")
            return UICollectionViewCell()
        }

        cell.updateCell(imageURL: viewModel.favoritedPicture[indexPath.row].urls?.regular ?? "https://via.placeholder.com/150")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (view.frame.size.width/3) - 3,
            height: (view.frame.size.width/3) - 3)
    }
    
    
    
}

private extension FavoritesViewController {
    
    func initializeVM() {
        initializeScreenDataObservable(subject: homeViewModel.screenDataRelay).disposed(by: disposeBag)
    }
    
    func initializeScreenDataObservable(subject: BehaviorRelay<[Picture]>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (items) in
                if !items.isEmpty {
                    viewModel.favoritedPicture = items.filter({ picture in
                        return picture.isFavorited ?? false
                    })
                    checkForFavoritePhotos()
                    self.collectionView.reloadData()
                }
            })
    }
    
}
