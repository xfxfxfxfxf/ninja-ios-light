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
        var Addr:String?
        var wJson:String?
        
        public static let shared = Wallet()
        private override init() {
                super.init()
        }
        
        lazy var loaded: Bool = {
                do {
                        var inst:Wallet?
                        inst = try CDManager.shared.GetOne(entity: "CDWallet", predicate: nil)
                        if inst == nil{
                                return false
                        }
                        
                        self.Copy(inst!)
                        NSLog("\(self.Addr!)")
                        NSLog("\(self.wJson!)")
                } catch{
                        return false
                }
                
                return self.obj != nil
        }()
        
        func Copy(_ a:Wallet){
                self.Addr = a.Addr
                self.wJson = a.wJson
                self.obj = a.obj
        }
        
        func New(_ password:String) throws {
                let walletJson =  IosLib.IosLibNewWallet(password)
                if walletJson == ""{
                        throw NJError.wallet("Create Wallet Failed")
                }
                let addr = IosLib.IosLibActiveAddress()
                if addr == ""{
                        throw NJError.wallet("Create Wallet Failed")
                }
                self.Addr = addr
                self.wJson = walletJson
                try CDManager.shared.Save(entity: "CDWallet", m: self)
        }
        func IsActive()->Bool{
                return IosLib.IosLibWalletIsOpen()
        }
}

extension Wallet:ModelObj{
        
        func fullFillObj(obj: NSManagedObject) throws {
                guard let wObj = obj as? CDWallet else{
                        throw NJError.coreData("Cast to CDWallet failed")
                }
                wObj.address = self.Addr
                wObj.jsonStr = self.wJson
                self.obj = wObj
        }
        
        
        func initByObj(obj: NSManagedObject) throws{
                guard let wObj = obj as? CDWallet else{
                        throw NJError.coreData("Cast to CDWallet failed")
                }
                self.obj = wObj
                self.Addr = wObj.address
                self.wJson = wObj.jsonStr
        }
}
