//
//  WebsocketCallback.swift
//  ninja-light
//
//  Created by wesley on 2021/4/6.
//

import Foundation
import IosLib
import SwiftyJSON

class WebsocketSrv:NSObject{
        public static var shared = WebsocketSrv()
        override init() {
                super.init()
        }
        
        func IsOnline() -> Bool {
                
                return IosLib.IosLibWSIsOnline()
        }
        
        func Online()->Error?{
                var err:NSError? = nil
                IosLib.IosLibWSOnline(&err)
                return err
        }
        
        func Offline() {
                IosLib.IosLibWSOffline()
        }
        
        func SendIMMsg(cliMsg:CliMessage) -> NJError?{
                var error:NSError?
                var data:Data
                do{
                        data = try cliMsg.ToNinjaPayload()
                }catch let err{
                        return NJError.msg(err.localizedDescription)
                }
                
                
                IosLib.IosLibWriteMessage(cliMsg.to, data, &error)
                if error != nil{
                        return NJError.msg(error!.localizedDescription)
                }
                
                MessageItem.addSentIM(cliMsg: cliMsg)
                ChatItem.updateLastMsg(msg: cliMsg, time: Int64(Date().timeIntervalSince1970), unread: 0)
                return nil
        }
}

extension WebsocketSrv:IosLibAppCallBackProtocol{
        
        func immediateMessage(_ from: String?, to: String?, payload: Data?, time: Int64) throws {
                
                let owner = Wallet.shared.Addr!
                if owner != to{
                        throw NJError.msg("this im is not for me")
                }
                
                let cliMsg = try CliMessage.FromNinjaPayload(payload!, to: to!)
                let msg = MessageItem.init(cliMsg:cliMsg, from:from!, time:time)
                
                
                MessageItem.receivedIM(msg: msg)
                ChatItem.updateLastMsg(msg: cliMsg, time: time, unread: 1)
        }
        
        func unreadMsg(_ jsonData: Data?) throws {
                guard let data = jsonData else {
                        return
                }
                
                let json = try JSON(data: data)
                let receiver = json["receiver"].string
                let owner = Wallet.shared.Addr!
                if receiver != owner{
                        throw NJError.msg("this unread is not for me")
                }
                
                var lastCliMsg:[String:CliMessage] = [:]
                var lastTime:[String:Int64] = [:]
                var unreadNo:[String:Int] = [:]
                
                for (_,subJson):(String, JSON) in json["payload"]{
                        let (msg, cliMsg) = MessageItem.InitWith(json:subJson)
                        MessageItem.addUnread(msg)
                        let to = msg.to!
                        if lastTime[to] ?? 0 < msg.timeStamp{
                                lastCliMsg[to] = cliMsg
                                lastTime[to] = msg.timeStamp
                        }
                        unreadNo[to] = unreadNo[to] ?? 0 + 1
                }
                
                ChatItem.updateAllLastMsg(msg: lastCliMsg, time: lastTime, unread: unreadNo)
        }
        
        func webSocketClosed() {
                
        }
}
