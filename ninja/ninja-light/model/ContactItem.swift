//
//  ContactItem.swift
//  ninja-light
//
//  Created by wesley on 2021/4/7.
//

import Foundation
import CoreData
import IosLib

class ContactItem:NSObject{
        public static var cache:[ContactItem]=[]
        
        var obj:CDContact?
        lazy var uid:String? = {
                return self.obj?.uid
        }()
        
        lazy var nickName:String? = {
                return self.obj?.nickName
        }()
        
        lazy var avatar:Data? = {
                return self.obj?.avatar
        }()
        lazy var remark:String? = {
                return self.obj?.remark
        }()
        lazy var owner:String? = {
                return Wallet.shared.Addr
        }()
        override init() {
                super.init()
        }
        
        public static func GetContact(_ uid:String) -> ContactItem?{
                var obj:ContactItem?
                obj = try? CDManager.shared.GetOne(entity: "CDContact", predicate: "uid == \(uid)")
                return obj
        }
        
        public static func AddNewContact(_ contact:ContactItem) -> NJError?{
                contact.owner = Wallet.shared.Addr!
                do {try CDManager.shared.Save(entity: "CDContact", m: contact)}catch let err{
                        return NJError.contact(err.localizedDescription)
                }
                return nil
        }
        
        public static func LocalSavedContact(){
                guard let owner = Wallet.shared.Addr else{
                        return
                }
                var result:[ContactItem]?
                result = try? CDManager.shared.Get(entity: "CDContact",
                                                   predicate: "owner == \(owner)",
                                                   sort: [["nickName" : true]])
                guard let arr = result else {
                        return
                }
                
                cache = arr
        }
        
        public static func IsValidContactID(_ uid:String)->Bool{
                return IosLib.IosLibIsValidNinjaAddr(uid)
        }
}

extension ContactItem:ModelObj{
        func fullFillObj(obj: NSManagedObject) throws {
                guard let cObj = obj as? CDContact else{
                        throw NJError.coreData("Cast to CDContact failed")
                }
                cObj.uid = self.uid
                cObj.nickName = self.nickName
                cObj.remark = self.remark
                cObj.avatar = self.avatar
                cObj.owner = self.owner
        }
        
        func initByObj(obj: NSManagedObject) throws {
                guard let cObj = obj as? CDContact else{
                        throw NJError.coreData("Cast to CDContact failed")
                }
                self.uid = cObj.uid
                self.nickName = cObj.nickName
                self.avatar = cObj.avatar
                self.remark = cObj.remark
                self.owner = cObj.owner
        }
}
