//
//  Motor.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 10/3/21.
//

import Foundation

public struct Motor: Codable, Identifiable, Equatable, Hashable {
    public var id: String
    var name: String
    
    var time: [Double]
    var thrust: [Double]
    
    var totalMass: Double
    var propellantMass: Double
}
