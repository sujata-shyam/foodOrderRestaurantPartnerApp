//
//  ViewController.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 15/01/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit

class loginViewController: UIViewController
{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtRestaurantID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lblTitle.layer.cornerRadius = 10
        lblTitle.layer.masksToBounds = true
        setTextDelegate()
    }

    func setTextDelegate()
    {
        txtRestaurantID.delegate = self
        txtPassword.delegate = self
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton)
    {
        if(txtRestaurantID.text!.isEmpty)
        {
            displayAlert(vc: self, title: "", message: "Please enter the ID.")
        }
        else
        {
            loadLoginData(txtRestaurantID.text!)
        }
        txtRestaurantID.resignFirstResponder()
        
    }
    
    func loadLoginData(_ restaurantID: String)
    {
        let searchURL = URL(string: "https://tummypolice.iyangi.com/api/v1/restaurant/login")
        var searchURLRequest = URLRequest(url: searchURL!)
        
        searchURLRequest.httpMethod = "POST"
        searchURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do
        {
            let jsonBody = try JSONEncoder().encode(RestaurantLoginRequest(
                name: restaurantID
            ))
            searchURLRequest.httpBody = jsonBody
        }
        catch
        {
            print(error)
        }
        
        URLSession.shared.dataTask(with: searchURLRequest){ data, response,error in
            guard let data =  data else { return }
            
//            let received = String(data: data, encoding: String.Encoding.utf8)
//            print("received: \(received)")
            
            do
            {

                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode)
                    else {
                        print(error as Any)
                        return
                }
                let restaurantResponse = try JSONDecoder().decode(Restaurant.self, from: data)


                if let _ = restaurantResponse.name
                {
                    DispatchQueue.main.async
                    {
                        displayAlert(vc: self, title: "", message: "Login Successful.")
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
}

extension loginViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
