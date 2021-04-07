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
}

extension WebsocketSrv:IosLibAppCallBackProtocol{
        
        func immediateMessage(_ from: String?, to: String?, payload: Data?, time: Int64) throws {
                
        }
        
        func unreadMsg(_ jsonData: Data?) throws {
                
        }
        
        func webSocketClosed() {
                
        }
}
