//
//  WebsocketCallback.swift
//  ninja-light
//
//  Created by wesley on 2021/4/6.
//

import Foundation
import IosLib

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
}

extension WebsocketSrv:IosLibAppCallBackProtocol{
        
        func immediateMessage(_ from: String?, to: String?, payload: Data?, time: Int64) throws {
                
        }
        
        func unreadMsg(_ jsonData: Data?) throws {
                
        }
        
        func webSocketClosed() {
                
        }
}
