//
//  ServiceDelegate.swift
//  ninja-light
//
//  Created by wesley on 2021/4/6.
//

import Foundation
import IosLib

class ServiceDelegate: NSObject {
        public static let workQueue = DispatchQueue.init(label: "Serivce Queue", qos: .utility)
        
        override init() {
                super.init()
        }
        
        public static func InitService(_ password:String)->Error?{
                var error:NSError? = nil
                let wallet = Wallet.shared
                //TODO:: boot node list showed on wallet tabview
                IosLib.IosLibInitApp(wallet.wJson, password, "", WebsocketSrv.shared, &error)
                return error
        }
}
