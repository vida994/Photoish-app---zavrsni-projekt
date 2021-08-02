//
//  PictureTableViewCell.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import UIKit
import SnapKit
import Kingfisher

class PictureTableViewCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(red: 0.996, green: 0.867, blue: 0.745, alpha: 1)
        return view
    }()
    
    let pictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let photographerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let favoriteImageView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Vector"), for: .normal)
        button.setImage(UIImage(named: "Vector")?.withTintColor(.black), for: .selected)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(photographerName: String, dateString: String, photoImageUrl: String, isfavorited: Bool) {
        photographerNameLabel.text = photographerName
        setDate(input: dateString)
        if let url = URL(string: photoImageUrl) {
            pictureImageView.kf.setImage(with: url)
        }
        if isfavorited {
            favoriteImageView.isSelected = true
        }
        else { favoriteImageView.isSelected = false}
    }
    
}

private extension PictureTableViewCell {
    
    func configureUI() {
        contentView.addSubviews(views: containerView, pictureImageView, photographerNameLabel, dateLabel, favoriteImageView)
        contentView.backgroundColor = UIColor(red: 0.196, green: 0.193, blue: 0.193, alpha: 1)
        setupConstraints()
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.bottom.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        }
        
        pictureImageView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.bottom.equalTo(containerView).inset(UIEdgeInsets(top: 15, left: 22, bottom: 55, right: 22))
        }
        
        photographerNameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(containerView).inset(22)
            maker.top.equalTo(pictureImageView.snp.bottom).offset(10)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(containerView).inset(22)
            maker.top.equalTo(photographerNameLabel.snp.bottom).offset(0)
        }
        
        favoriteImageView.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(containerView).inset(22)
            maker.top.equalTo(pictureImageView.snp.bottom).offset(15)
            maker.height.width.equalTo(25)
        }
    }
    
    func setDate(input: String){
        var stringDate = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: input) {
            stringDate = date
            
        }
        
        formatter.dateFormat = "MMM d, yyyy"
        dateLabel.text = formatter.string(from: stringDate)
     }
}
