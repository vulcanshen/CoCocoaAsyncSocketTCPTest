//
//  ViewController.swift
//  TCPTest
//
//  Created by kutai on 2015/10/21.
//  Copyright © 2015年 kutai. All rights reserved.
//

import UIKit
extension NSData {
    func getByteArray() -> [UInt8]? {
        var byteArray: [UInt8] = [UInt8]()
        for i in 0..<self.length {
            var temp: UInt8 = 0
            self.getBytes(&temp, range: NSRange(location: i, length: 1))
            byteArray.append(temp)
        }
        return byteArray
    }
}

class ViewController: UIViewController, AsyncSocketDelegate {

    var socket: AsyncSocket!
    
    @IBOutlet weak var tvRead: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        socket = AsyncSocket(delegate: self)

        do {
            try socket.connectToHost("172.20.10.2", onPort: 4349)
        }catch let error as NSError {
            print(error)
        }
    }
    
    
    func onSocketDidDisconnect(sock: AsyncSocket!) {
        print("disconnect")
        
    }
    
    func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        print("will disconnect with error:\(err)")
        socket.disconnect()
    }
    
    
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        let bytearr:[UInt8] = [1,2,3]
        let data: NSData = NSData(bytes: bytearr, length: bytearr.count)
        socket.writeData(data, withTimeout: 0, tag: 0)
        socket.readDataWithTimeout(10, tag: 0)
    }
    
    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        print("read\(data.getByteArray())")
        
        tvRead.text = tvRead.text + "\n" + (data.getByteArray()?.description)!
        socket.readDataWithTimeout(10, tag: 0)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

