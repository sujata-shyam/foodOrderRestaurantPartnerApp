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
    
//    let manager = SocketManager(socketURL: URL(string: "https://tummypolice.iyangi.com")!)
//    var socket: SocketIOClient!
    
    //var order:OrderDetail?
    
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

                if restaurantResponse.id != nil
                {
                    self.restaurantID = restaurantResponse.id!

                    //self.socket = self.manager.defaultSocket
                    //self.setSocketEvents(restaurantId)
                    //self.closeSocketConnection()
                    
                    DispatchQueue.main.async
                    {
                        //displayAlert(vc: self, title: "", message: "Login Successful.")
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
    
    //MARK:- Socket functions
    
//    private func setSocketEvents(_ restaurantId:String)
//    {
//        self.socket.on(clientEvent: .connect) { (data, ack) in
//            print(data)
//            print("Socket connected")
//            self.socket.emit("active restaurant", restaurantId)
//        }
//
//        self.socket.on("order details") {data, ack in
//            print(data)
//            do
//            {
//                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//
//                let orderDetail = try JSONDecoder().decode([OrderDetail].self, from: jsonData)
//
//                print(orderDetail)
//
//                if let orderID = orderDetail.first?.orderId
//                {
//                    print(orderID)
//                    self.order = orderDetail.first
//                    self.performSegue(withIdentifier: "goToOrderDetails", sender: self)
////                    DispatchQueue.main.async
////                    {
////                        //Update UI for tableview
////                    }
//                }
////                else
////                {
////                    DispatchQueue.main.async
////                    {
////                        displayAlert(vc: self, title: "Failed Login Attempt", message: "User does not exist")
////                    }
////                }
//            }
//            catch
//            {
//                print(error)
//            }
//
//
//        }
//
////        socket.on("currentAmount") {data, ack in
////            guard let cur = data[0] as? Double else { return }
////
////            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
////                socket.emit("update", ["amount": cur + 2.50])
////            }
////
////            ack.with("Got your currentAmount", "dude")
////        }
//
//
//        self.socket.connect()
//    }
//
//    private func closeSocketConnection() {
//        self.socket.disconnect()
//    }
}

extension loginViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
