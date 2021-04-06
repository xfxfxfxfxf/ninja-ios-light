//
//  ServiceDelegate.swift
//  ninja-light
//
//  Created by wesley on 2021/4/6.
//

import Foundation
import IosLib

class ServiceDelegate: NSObject {
        
        override init() {
                super.init()
        }
        
        public static func InitService(){
                var error:NSError?
                if !Wallet.shared.hasWallet{
                        IosLib.IosLibInitApp("", "", WebsocketCallback.shared, &error)
                }
        }
}
