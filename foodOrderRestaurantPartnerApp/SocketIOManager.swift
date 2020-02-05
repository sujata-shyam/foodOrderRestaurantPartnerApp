//
//  SocketIOManager.swift
//  foodOrderRestaurantPartnerApp
//
//  Created by Sujata on 05/02/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject
{
    static let sharedInstance = SocketIOManager()
    var socket:SocketIOClient!
    
    let manager = SocketManager(socketURL: URL(string: "https://tummypolice.iyangi.com")!, config: [.log(true)])
    
    override init()
    {
        super.init()
        socket = manager.defaultSocket
    }
    
    func establishConnection()
    {
        socket.connect()
        socket.on(clientEvent: .connect) {data, ack in
            print("Socket Connected!")
            //self.onOrderDetails()
            
            self.socket.on("order details") {data, ack in
                
                print("onOrderDetails :\(data)")
                do
                {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    
                    let orderDetail = try JSONDecoder().decode([OrderDetail].self, from: jsonData)
                    
                    print(orderDetail)
                    
                    if let orderID = orderDetail.first?.orderId
                    {
                        print(orderID)
                        
                        //let orderItem = Array(orderDetail.first!.cartItems!.values) as! [CartItemDetail]
                        
                        NotificationCenter.default.post(name: NSNotification.Name("gotOrderDetail"), object: orderDetail)
                    }
                }
                catch
                {
                    print(error)
                }
            }
            
        }
    }
    
    func closeConnection()
    {
        socket.disconnect()
        socket.on(clientEvent: .disconnect)
        {data, ack in
            print("Socket Disconnected!")
        }
    }
    
    func emitOrderApproved(_ orderId:String)
    {
        self.socket.emit("order approved", orderId)
    }
    
    func emitActiveRestaurant(_ restaurantId: String)
    {
        self.socket.emit("active restaurant", restaurantId)
    }
    
    func onOrderDetails()
    {
        self.socket.on("order details") {data, ack in
            
            print("onOrderDetails :\(data)")
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                
                let orderDetail = try JSONDecoder().decode([OrderDetail].self, from: jsonData)
                
                print(orderDetail)
                
                if let orderID = orderDetail.first?.orderId
                {
                    print(orderID)
                
                    //let orderItem = Array(orderDetail.first!.cartItems!.values) as! [CartItemDetail]
                    
                    NotificationCenter.default.post(name: NSNotification.Name("gotOrderDetail"), object: orderDetail)
                }
            }
            catch
            {
                print(error)
            }
        }
    }
}

