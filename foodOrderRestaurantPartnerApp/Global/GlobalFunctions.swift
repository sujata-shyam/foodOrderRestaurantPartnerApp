//
//  GlobalFunctions.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 15/01/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit

var activityIndicator = UIActivityIndicatorView()

func displayAlert(vc: UIViewController, title: String, message: String)
{
    let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:nil ))
    vc.present(alert, animated: true)
}

/* Below: function to start Activity Indicator */
func startActivityIndicator(vc: UIViewController)
{
    activityIndicator.center = vc.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = UIActivityIndicatorView.Style.gray
    vc.view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
}

/* Below: function to stop Activity Indicator */
func stopActivityIndicator(vc: UIViewController)
{
    activityIndicator.stopAnimating()
    UIApplication.shared.endIgnoringInteractionEvents()
}
