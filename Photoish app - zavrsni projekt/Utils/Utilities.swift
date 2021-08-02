//
//  Utilities.swift
//  Photoish app - zavrsni projekt
//
//  Created by Factory on 29.07.2021..
//

import UIKit

class SerializationManager {
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .deferredToData
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    public func parse(jsonData: Data) -> [Picture]?{
        var object = [Picture]()
        do {
            let parsedObject = try SerializationManager.jsonDecoder.decode([Picture].self, from: jsonData)
            object = parsedObject
            print("")
            
        } catch {
            print("Print error: \(error)")
        }
        return object
    }
}
