//
//  MessageItem.swift
//  ninja-light
//
//  Created by wesley on 2021/4/7.
//

import Foundation
import CoreData
import SwiftyJSON

typealias MessageList = Array<MessageItem>

class MessageItem: NSObject {
        var timeStamp:Int64 = 0
        var from:String?
        var to:String?
        var typ:CMT = .plainTxt
        var payload:Data?
        
        
        public static var cache:[String:MessageList] = [:]
        override init() {
                super.init()
        }
        
        static func InitWith(json:JSON) -> (MessageItem, CliMessage?){
                let msg = MessageItem.init()
                msg.from = json["From"].string
                msg.to = json["To"].string
                msg.timeStamp = json["UnixTime"].int64 ?? 0
                let data = json["PayLoad"].object as? Data
                let cliMsg = try? CliMessage.FromNinjaPayload(data!, to: msg.to!)
                msg.typ = cliMsg!.type
                msg.payload = cliMsg?.data
                
                return (msg, cliMsg)
        }
        
        init(cliMsg:CliMessage, from: String, time: Int64){
                super.init()
                self.from = from
                self.timeStamp = time
                self.to = cliMsg.to
                self.typ = cliMsg.type
                self.payload = cliMsg.data
        }
        
        public static func addSentMessage(cliMsg:CliMessage){
                
                let sender = Wallet.shared.Addr!
                let msg = MessageItem.init()
                msg.from = sender
                msg.to = cliMsg.to
                msg.typ = cliMsg.type
                msg.payload = cliMsg.data
                
                var list = cache[msg.to!]
                if list == nil{
                        list = Array.init()
                }
                list!.append(msg)
        }
        
        public static func receivedIM(msg:MessageItem){
                var list = cache[msg.to!]
                if list == nil{
                        list = Array.init()
                }
                list!.append(msg)
        }
        
        public static func addUnread(_ msg:MessageItem){
                
        }
}

extension MessageItem:ModelObj{
        
        func fullFillObj(obj: NSManagedObject) throws {
        }
        
        func initByObj(obj: NSManagedObject) throws {
        }
}
