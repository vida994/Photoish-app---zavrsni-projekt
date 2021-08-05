//
//  FavoritePhotoCollectionViewCell.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 05.08.2021..
//

import UIKit
import SnapKit
import Kingfisher

class FavoritePhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "reuseID"
    
    let image: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(imageURL: String) {
        
        if let url = URL(string: imageURL) {
            image.kf.setImage(with: url)
        }
    }
    
}

private extension FavoritePhotoCollectionViewCell {
    
    func configureUI() {
        contentView.addSubview(image)
        contentView.backgroundColor = .clear
        setupConstraints()
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.equalTo(contentView)
        }
    }
    
}
