//
//  User.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 15/01/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import Foundation

struct RestaurantLoginRequest:Codable
{
    let name : String?
}

struct Restaurant:Codable
{
    let id : String?
    let name : String?
    let description : String?
    let city : String?
    let location: String?
    let latitude: String?
    let longitude: String?
}
