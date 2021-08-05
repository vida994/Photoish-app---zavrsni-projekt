//
//  UIView+Extension.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import UIKit

extension UIView {
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

extension UIColor {
    static var mainColor: UIColor  { return UIColor(red: 0.196, green: 0.193, blue: 0.193, alpha: 1) }
}
