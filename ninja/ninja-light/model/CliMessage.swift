//
//  CliMessage.swift
//  ninja-light
//
//  Created by wesley on 2021/4/7.
//

import Foundation
import SwiftyJSON


enum CMT:Int {
        case plainTxt
        case voice
        case location
        case contact
}

class CliMessage: NSObject {
        var to:String?
        var type:CMT = .plainTxt
        var data:Data?
        override init(){
                super.init()
        }
        init(to:String, data:Data, type:CMT = .plainTxt) {
                super.init()
                self.to = to
                self.data = data
                self.type = type
        }
        
        func ToNinjaPayload() throws -> Data {
                var jObj:JSON = [:]
                jObj["type"].int = self.type.rawValue
                jObj["data"].object = self.data as Any
                return try jObj.rawData()
        }
        
        static func  FromNinjaPayload(_ data:Data, to:String)throws -> CliMessage{
                let cliMsg = CliMessage.init()
                
                let json = try JSON(data: data)
                cliMsg.type = CMT(rawValue: json["type"].int!) ?? .plainTxt
                cliMsg.data = json["data"].object as? Data
                cliMsg.to = to
                
                return cliMsg
        }
        
        func coinvertToLastMsg() -> String{
                switch self.type {
                case .plainTxt:
                        return String(String.init(data: self.data!, encoding: .utf8)!.prefix(20))
                case .voice:
                        return "[Voice Message]"
                case .location:
                        return "[Location]"
                case .contact:
                        return "[Contact]"
                }
        }
}
