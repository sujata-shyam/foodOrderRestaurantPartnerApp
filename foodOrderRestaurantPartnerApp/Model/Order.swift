//
//  Order.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 17/01/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import Foundation

struct Bill:Codable
{
    let deliveryfee: Double?
    let subtotal: Double?
    let total: Double?
}

struct CartItemDetail:Codable
{
    let name: String?
    let price: Double?
    var quantity: Int?
}

struct Location:Codable
{
    let latitude : String?
    let longitude : String?
}

struct OrderDetail:Codable
{
    let bill: Bill?
    let cartItems : [String:CartItemDetail?]?
    let location : Location?
    let orderId : String?
    let restaurantId : String?
}


