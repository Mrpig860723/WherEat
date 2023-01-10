//
//  ObjectSavableError.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/10.
//

import Foundation


enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
