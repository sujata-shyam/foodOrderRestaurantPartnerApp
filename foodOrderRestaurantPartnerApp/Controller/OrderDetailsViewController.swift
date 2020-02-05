//
//  OrderDetailsViewController.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 16/01/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit
//import SocketIO

class OrderDetailsViewController: UIViewController
{
    @IBOutlet weak var lblNoOrder: UILabel!
    @IBOutlet weak var viewOrderDetails: UIView!
    @IBOutlet weak var orderTableView: UITableView!
 
    //let manager = SocketManager(socketURL: URL(string: "https://tummypolice.iyangi.com")!)
//    let manager = SocketManager(socketURL: URL(string: "https://tummypolice.iyangi.com")!, config: [.log(true)])
//
//    
//    var socket: SocketIOClient!
    
    var restaurantId : String? //Value passed from prev.View Controller thru. segue
    var orderItem = [CartItemDetail]()
    var orderId : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        //self.socket = self.manager.defaultSocket
        //self.setSocketEvents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleIncomingOrder), name: NSNotification.Name("gotOrderDetail"), object: nil)
    }
    
    @objc func handleIncomingOrder(notification: Notification)
    {
        let orderDetail = notification.object as! [OrderDetail]
        
        //print("Notification orderDetail: \(orderDetail)")
        
        if let orderID = orderDetail.first?.orderId
        {
            print("Notification orderID: \(orderID)")
            
            self.orderItem = Array(orderDetail.first!.cartItems!.values) as! [CartItemDetail]
            self.orderId = orderID
            
            DispatchQueue.main.async
            {
                self.lblNoOrder.isHidden = true
                self.viewOrderDetails.isHidden = false
                self.orderTableView.reloadData()
            }
        }
        else
        {
            DispatchQueue.main.async
            {
                self.lblNoOrder.isHidden = false
                self.viewOrderDetails.isHidden = true
            }
        }
    }
    
    @IBAction func btnAcceptOrderTapped(_ sender: UIButton)
    {
        if(orderId != nil)
        {
            //self.socket.emit("order approved", self.orderId!)
            SocketIOManager.sharedInstance.emitOrderApproved(self.orderId!)
        }
    }
    
    //MARK:- Socket functions
    
//    private func setSocketEvents()
//    {
//        self.socket.on(clientEvent: .connect) { (data, ack) in
//            print(data)
//            print("Socket connected")
//            self.socket.emit("active restaurant", self.restaurantId!)
//        }
        
//        self.socket.on("order details") {data, ack in
//
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
//
//                    self.orderItem = Array(orderDetail.first!.cartItems!.values) as! [CartItemDetail]
//                    self.orderId = orderID
//
//                    DispatchQueue.main.async
//                    {
//                        self.lblNoOrder.isHidden = true
//                        self.viewOrderDetails.isHidden = false
//                        self.orderTableView.reloadData()
//                    }
//                }
//                else
//                {
//                    DispatchQueue.main.async
//                    {
//                        self.lblNoOrder.isHidden = false
//                        self.viewOrderDetails.isHidden = true
//                    }
//                }
//            }
//            catch
//            {
//                print(error)
//            }
//        }
        //self.socket.connect()
    }
    
//    private func closeSocketConnection()
//    {
//        self.socket.disconnect()
//    }
//}


extension OrderDetailsViewController: UITableViewDelegate,
UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return orderItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetailCell", for: indexPath) as! orderDetailTableViewCell
        cell.lblItemName.text = orderItem[indexPath.row].name
        cell.lblItemQuantity.text = String((orderItem[indexPath.row].quantity)!)
        
        return cell
    }
    
}
