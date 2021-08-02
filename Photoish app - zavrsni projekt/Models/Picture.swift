//
//  Picture.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import UIKit

struct Picture: Codable {
    let id: String?
    let createdAt: String?
    let likes: Int?
    let description: String?
    let user: User?
    let urls: Urls?
    var isFavorited: Bool?
}

struct User: Codable {
    let name: String?
}


struct Urls: Codable {
    let regular: String?
}
