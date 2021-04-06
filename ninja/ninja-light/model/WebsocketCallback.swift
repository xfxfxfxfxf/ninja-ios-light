//
//  WebsocketCallback.swift
//  ninja-light
//
//  Created by wesley on 2021/4/6.
//

import Foundation
import IosLib

class WebsocketCallback:NSObject{
       public static var shared = WebsocketCallback()
        override init() {
                super.init()
        }
}

extension WebsocketCallback:IosLibAppCallBackProtocol{
        
        func immediateMessage(_ from: String?, to: String?, payload: Data?, time: Int64) throws {
                
        }
        
        func unreadMsg(_ jsonData: Data?) throws {
                
        }
        
        func webSocketClosed() {
                
        }
}
