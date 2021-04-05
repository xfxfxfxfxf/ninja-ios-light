//
//  Wallet.swift
//  ninja-light
//
//  Created by wesley on 2021/4/5.
//

import Foundation
import CoreData

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
                
        }
}
extension Wallet:ModelObj{
        
        func fullFillObj(obj: NSManagedObject) {
                
        }
        
        func initByObj(obj: NSManagedObject) {
                
        }
}
