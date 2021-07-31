//
//  Restaurant.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 4.06.2021.
//

import Foundation

struct Restaurant: Codable {
    var id: Int?
    var rest_name: String?
    var rest_description: String?
    var rest_image_url: String?
    var rest_location: [String]
}

struct Location: Codable {
    var rest_location_id: Int?
    var rest_location_street: String?
}
