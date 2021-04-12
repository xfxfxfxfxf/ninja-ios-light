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
        var type:CMT = .plainTxt
        var data:Data?
        
        init(data:Data, type:CMT = .plainTxt) {
                super.init()
                self.data = data
                self.type = type
        }
        
        func ToNinjaPayload() throws -> Data {
                var jObj:JSON = [:]
                jObj["type"].int = self.type.rawValue
                jObj["data"] = JSON(self.data as Any)
                return try jObj.rawData()
        }
}
