//
//  User.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 10.06.2021.
//

import Foundation

struct Card : Codable, Hashable{
    var cardHolderName: String?
    var cardNumber: String?
    var dateMonth: String?
    var dateYear: String?
    var cvv: String?
    var key: String?
}

struct User : Codable {
    var name: String?
    var profileURL: String?
    var surname: String?
    var phone: String
    var gender: String?
    var birthDate: String?
    var cards: [Card]?
    var orders: [Order]?
}

struct Order : Codable {
    var restaurantName: String?
    var date: String?
    var totalPrice: Double?
    var seatNumber: String?
    var orderItems: [String : OrderItem]?
}

struct OrderItem : Codable {
    var id: Int
    var categoryId: Int
    var description: String?
    var imageUrl: String?
    var name: String?
    var price: Double?
    var restaurantId: Int?
    var count: Int?
}
