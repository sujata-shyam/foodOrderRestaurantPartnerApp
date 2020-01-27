//
//  GlobalFunctions.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 15/01/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard

func displayAlert(vc: UIViewController, title: String, message: String)
{
    let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:nil ))
    vc.present(alert, animated: true)
}
