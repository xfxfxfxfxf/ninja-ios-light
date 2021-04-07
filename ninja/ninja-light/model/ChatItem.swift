//
//  ChatItem.swift
//  ninja-light
//
//  Created by wesley on 2021/4/7.
//

import Foundation
import CoreData

class ChatItem:NSObject{
        
        public static var CachedChats:[ChatItem] = []
        
        var obj:CDChatItem?
        lazy var ItemID:String? = {
                if self.obj == nil{
                        return nil
                }
                return self.obj!.uid
        }()
        
        lazy var ImageData:Data? = {
                if self.obj == nil{
                        return nil
                }
                return self.obj!.image
        }()
        
        lazy var NickName:String? = {
                if self.obj == nil{
                        return nil
                }
                return self.obj!.nickName
        }()
        
        var LastMsg:String?
        
        override init() {
                super.init()
        }
        
        public static func ReloadChatRoom(){
                
        }
        
}
extension ChatItem:ModelObj{
        
        func fullFillObj(obj: NSManagedObject) throws {
        }
        
        func initByObj(obj: NSManagedObject) throws {
        }
}
