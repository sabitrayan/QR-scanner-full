//
//  MenuItem.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 04.06.2021.
//

import Foundation

struct MenuItem : Codable, Hashable {
    var id: Int?
    var categoryId: Int?
    var description: String?
    var imageUrl: String?
    var name: String?
    var price: Double?
    var restaurantId: Int?
}

