//
//  completionViewController.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 06/02/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit

class completionViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func btnLogoutTapped(_ sender: UIButton)
    {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
}
