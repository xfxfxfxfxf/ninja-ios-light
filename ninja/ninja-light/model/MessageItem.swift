//
//  MessageItem.swift
//  ninja-light
//
//  Created by wesley on 2021/4/7.
//

import Foundation
import CoreData
import SwiftyJSON

typealias MessageList = [MessageItem]

class MessageItem: NSObject {
        public static let NotiKey = "peerUid"
        var timeStamp:Int64 = 0
        var from:String?
        var to:String?
        var typ:CMT = .plainTxt
        var payload:String?
        
        
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
        
        public static func addSentIM(cliMsg:CliMessage){
                
                let sender = Wallet.shared.Addr!
                let msg = MessageItem.init()
                msg.from = sender
                msg.to = cliMsg.to
                msg.typ = cliMsg.type
                msg.payload = cliMsg.data
                
                if cache[msg.to!] == nil{
                        cache[msg.to!] = []
                }
                cache[msg.to!]!.append(msg)
        }
        
        public static func receivedIM(msg:MessageItem){
                if cache[msg.from!] == nil{
                        cache[msg.from!] = []
                }
                cache[msg.from!]!.append(msg)
                cache[msg.from!]!.sort(by: { (a, b) -> Bool in
                        return a.timeStamp < b.timeStamp
                })
                
                NotificationCenter.default.post(name:NotifyMessageAdded,
                                                object: self, userInfo:[NotiKey:msg.from!])
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

extension MessageList{
        
        func toString() -> String {
                
                var str = ""
                for msg in self{
                        switch msg.typ {
                        case .plainTxt:
                                str += msg.payload!
                                str += "\r\n"
                        case .contact://TODO::
                                str += "Contact TODO::\r\n"
                        case .voice://TODO::
                                str += "Voice TODO::\r\n"
                        case .location://TODO::
                                str += "Location TODO::\r\n"
                        }
                }
                return str
        }
}
