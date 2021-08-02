//
//  HomeViewController.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundView = nil
        tv.backgroundColor = .clear
        tv.rowHeight = 244
        return tv
    }()
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "LOGO")
        return image
    }()
    
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        setupTableView()
        initializeVM()
        viewModel.loadDataSubject.onNext(())
    }

}

private extension HomeViewController {
    
    func setupTableView() {
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerCells() {
        tableView.register(PictureTableViewCell.self, forCellReuseIdentifier: "pictureTableViewCell")
    }
    
    func configureUI() {
        view.backgroundColor = UIColor(red: 0.196, green: 0.193, blue: 0.193, alpha: 1)
        tabBarController?.tabBar.barTintColor = UIColor(red: 0.114, green: 0.114, blue: 0.114, alpha: 0.94)
        title = "Home"
        tabBarItem.image = UIImage(systemName: "house")
        view.addSubviews(views: progressView, logoImage, tableView)
        view.bringSubviewToFront(progressView)
        configureConstraints()
    }
    
    func configureConstraints() {
        progressView.snp.makeConstraints({ (maker) in
            maker.centerX.centerY.equalToSuperview()
        })
        
        logoImage.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            maker.height.width.equalTo(75)
            maker.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(logoImage.snp.bottom).offset(10)
            maker.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

private extension HomeViewController {
    
    func initializeVM() {
        disposeBag.insert(viewModel.initializeViewModelObservables())
        initializeLoaderObservable(subject: viewModel.loaderSubject).disposed(by: disposeBag)
        initializeScreenDataObservable(subject: viewModel.screenDataRelay).disposed(by: disposeBag)
    }
    
    func initializeLoaderObservable(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (status) in
                if status {
                    showLoader()
                } else {
                    hideLoader()
                }
            })
    }
    
    func initializeScreenDataObservable(subject: BehaviorRelay<[Picture]>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (items) in
                if !items.isEmpty {
                    self.tableView.reloadData()
                }
            })
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.screenDataRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pictureCell = tableView.dequeueReusableCell(withIdentifier: "pictureTableViewCell", for: indexPath) as? PictureTableViewCell else {
            print("failed to dequeue the cell in Home View Controller")
            return UITableViewCell()
        }
        let picture = viewModel.screenDataRelay.value[indexPath.row]
        
        pictureCell.configureCell(photographerName: picture.user?.name ?? "Missing a cool name", dateString: picture.createdAt ?? "", photoImageUrl: picture.urls?.regular ?? "", isfavorited: picture.isFavorited ?? false)
        
        
        return pictureCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(viewModel: viewModel, indexPath: indexPath.row)
        
        present(detailViewController, animated: true, completion: nil)
    }
}

extension HomeViewController {
    
    func showLoader() {
        progressView.isHidden = false
        progressView.startAnimating()
    }
    
    func hideLoader() {
        progressView.isHidden = true
        progressView.stopAnimating()
    }
}
