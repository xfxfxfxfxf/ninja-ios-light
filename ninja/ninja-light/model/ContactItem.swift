//
//  ContactItem.swift
//  ninja-light
//
//  Created by wesley on 2021/4/7.
//

import Foundation
import CoreData

class ContactItem:NSObject{
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
        
        override init() {
                super.init()
        }
        
        public static func AddNewContact(_ uid:String) -> NJError?{
                var obj:ContactItem?
                obj = try? CDManager.shared.GetOne(entity: "CDContact", predicate: "uid == \(uid)")
                if obj != nil{
                        return NJError.contact("Already exist")
                }
                let contact = ContactItem.init()
                contact.uid = uid
                do {try CDManager.shared.Save(entity: "CDContact", m: contact)}catch let err{
                        return NJError.contact(err.localizedDescription)
                }
                return nil
        }
}
extension ContactItem:ModelObj{
        func fullFillObj(obj: NSManagedObject) throws {
                
        }
        
        func initByObj(obj: NSManagedObject) throws {
                
        }
        
        
}
