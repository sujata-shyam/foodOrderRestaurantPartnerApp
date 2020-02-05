//
//  ViewController.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 15/01/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit
import SocketIO

class loginViewController: UIViewController
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtRestaurantID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var restaurantID : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setTitleLabelUI()
        setTextDelegate()
    }

    func setTitleLabelUI()
    {
        lblTitle.layer.cornerRadius = 10
        lblTitle.layer.masksToBounds = true
    }
    
    func setTextDelegate()
    {
        txtRestaurantID.delegate = self
        txtPassword.delegate = self
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton)
    {
        if(txtRestaurantID.text!.isEmpty || txtPassword.text!.isEmpty)
        {
            displayAlert(vc: self, title: "", message: "Please enter the details.")
        }
        else
        {
            loadLoginData(txtRestaurantID.text!)
        }
    }
    
    func loadLoginData(_ restaurantName: String)
    {
        let searchURL = URL(string: "https://tummypolice.iyangi.com/api/v1/restaurant/login")
        
        var searchURLRequest = URLRequest(url: searchURL!)
        
        searchURLRequest.httpMethod = "POST"
        searchURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do
        {
            let jsonBody = try JSONEncoder().encode(RestaurantLoginRequest(
                name: restaurantName
            ))
            searchURLRequest.httpBody = jsonBody
        }
        catch
        {
            print(error)
        }
        
        URLSession.shared.dataTask(with: searchURLRequest){ data, response,error in
            guard let data =  data else
            {
                DispatchQueue.main.async
                {
                    displayAlert(vc: self, title: "", message: "Sorry. Connection Failed.")
                }
                return
            }
            
            do
            {
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode)
                    else {
                        print(error as Any)
                        return
                }
                let restaurantResponse = try JSONDecoder().decode(Restaurant.self, from: data)

                if restaurantResponse.id != nil
                {
                    self.restaurantID = restaurantResponse.id!
                    SocketIOManager.sharedInstance.emitActiveRestaurant(self.restaurantID!)
                    
                    DispatchQueue.main.async
                    {
                        self.performSegue(withIdentifier: "goToOrderDetails", sender: self)
                    }
                }
                else
                {
                    DispatchQueue.main.async
                    {
                        displayAlert(vc: self, title: "Failed Login Attempt", message: "Login ID does not exist")
                    }
                }
            }
            catch
            {
                print(error)
            }
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let orderVC = segue.destination as? OrderDetailsViewController
        {
            orderVC.restaurantId = restaurantID
        }
    }    
}

extension loginViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
