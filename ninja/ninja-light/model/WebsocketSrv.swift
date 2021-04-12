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
        
        func SendIMMsg(to: String, payLoad:CliMessage) -> NJError?{
                var error:NSError?
                var data:Data
                do{
                        data = try payLoad.ToNinjaPayload()
                }catch let err{
                        return NJError.msg(err.localizedDescription)
                }
                
                
                IosLib.IosLibWriteMessage(to, data, &error)
                if error != nil{
                        return NJError.msg(error!.localizedDescription)
                }
                return nil
        }
}

extension WebsocketSrv:IosLibAppCallBackProtocol{
        
        func immediateMessage(_ from: String?, to: String?, payload: Data?, time: Int64) throws {
                
        }
        
        func unreadMsg(_ jsonData: Data?) throws {
                
        }
        
        func webSocketClosed() {
                
        }
}
