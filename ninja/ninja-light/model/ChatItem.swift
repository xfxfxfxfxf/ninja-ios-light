//
//  ChatItem.swift
//  ninja-light
//
//  Created by wesley on 2021/4/7.
//

import Foundation
import CoreData

class ChatItem:NSObject{
        
        public static var CachedChats:[String:ChatItem] = [:]
        
        var ItemID:String?
        var ImageData:Data?
        var NickName:String?
        var LastMsg:String?
        var updateTime:Int64 = 0
        var unreadNo:Int = 0
        
        override init() {
                super.init()
        }
        
        public static func ReloadChatRoom(){
        }
        
        public static func updateLastMsg(msg:CliMessage, time:Int64, unread no:Int){
                var chat = CachedChats[msg.to!]
                if chat == nil{
                        chat = ChatItem.init()
                        chat!.ItemID = msg.to
//                        chat!.ima = //TODO::
//                        chat!.NickName = //TODO::
                          chat!.updateTime = time
                }
                if chat!.updateTime >= time{
                        return
                }
                
                
                chat!.unreadNo += no
                chat!.LastMsg = msg.coinvertToLastMsg()
                
                NotificationCenter.default.post(name:NotifyMsgSumChanged,
                                                object: self, userInfo:["peerID":msg.to!])
        }
        
        public static func updateAllLastMsg(msg:[String:CliMessage], time:[String:Int64], unread:[String:Int]){
                
        }
        
        public static func SortedArra() ->[ChatItem]{
                var sortedArray:[ChatItem] = []
                guard CachedChats.count > 0 else {
                        return sortedArray
                }
                for (_, item) in CachedChats{
                        sortedArray.append(item)
                }
                sortedArray.sort { (a, b) -> Bool in
                        return a.updateTime < b.updateTime
                }
                return sortedArray
        }
}
extension ChatItem:ModelObj{
        
        func fullFillObj(obj: NSManagedObject) throws {
        }
        
        func initByObj(obj: NSManagedObject) throws {
        }
}
