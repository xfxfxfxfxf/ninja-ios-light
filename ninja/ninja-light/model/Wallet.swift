//
//  Wallet.swift
//  ninja-light
//
//  Created by wesley on 2021/4/5.
//

import Foundation
import CoreData
import IosLib

class Wallet:NSObject{
        var obj:CDWallet?
        public static let shared = Wallet()
        private override init() {
                super.init()
        }
        func valid() -> Bool {
                return obj != nil
        }
        
        func New(_ password:String) throws {
               let result =  IosLib.IosLibNewWallet(password)
                NSLog("\(result)")
        }
}
extension Wallet:ModelObj{
        
        func fullFillObj(obj: NSManagedObject) {
                
        }
        
        func initByObj(obj: NSManagedObject) {
                
        }
}
