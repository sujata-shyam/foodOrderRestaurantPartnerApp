//
//  OrderDetailsViewController.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 16/01/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController
{
    @IBOutlet weak var lblNoOrder: UILabel!
    @IBOutlet weak var viewOrderDetails: UIView!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var btnAcceptOrder: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    
    var restaurantId : String? //Value passed from prev.View Controller thru. segue
    var orderItem = [CartItemDetail]()
    var orderId : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleIncomingOrder), name: NSNotification.Name("gotOrderDetail"), object: nil)
    }
    
    @objc func handleIncomingOrder(notification: Notification)
    {
        let orderDetail = notification.object as! [OrderDetail]
        
        if let orderID = orderDetail.first?.orderId
        {            
            self.orderItem = Array(orderDetail.first!.cartItems!.values) as! [CartItemDetail]
            self.orderId = orderID
            
            DispatchQueue.main.async
            {
                self.lblNoOrder.isHidden = true
                self.viewOrderDetails.isHidden = false
                self.lblOrderNumber.text = "ORDER #\(orderID.prefix(6))"
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
            SocketIOManager.sharedInstance.emitOrderApproved(self.orderId!)
            
            btnCompleted.isEnabled = true
            btnCompleted.setTitleColor(#colorLiteral(red: 0.737254902, green: 0.1921568627, blue: 0.08235294118, alpha: 1), for: .normal)
            
            btnAcceptOrder.isEnabled = false
            btnAcceptOrder.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.537254902, blue: 0.5568627451, alpha: 1), for: .normal)
        }
    }
    
    @IBAction func btnCompletedTapped(_ sender: UIButton)
    {
        performSegue(withIdentifier: "goToCompletion", sender: sender)
    }
}
    
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
