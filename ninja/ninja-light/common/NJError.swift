//
//  NJError.swift
//  ninja-light
//
//  Created by wesley on 2021/4/6.
//

import Foundation

public enum NJError: Error,LocalizedError {
        
        case wallet(String)
        case coreData(String)
        public var localizedDescription: String? {
                switch self {
                case .wallet(let err): return "[Wallet Error]:=>[\(err)]"
                case .coreData(let err): return "[CoreData Error]:=>[\(err)]"
                }
        }
}
