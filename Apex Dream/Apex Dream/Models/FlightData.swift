//
//  SimData.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 23/3/21.
//

import Foundation

struct FlightData {
    var id: String = "trial"
    var rocket: Rocket = Rocket()
    
    var time: [Double] = []
    
    var thrust: [Vector] = []
    var weight: [Vector] = []
    var drag: [Vector] = []
    var lift: [Vector] = []
    
    var acceleration: [Vector] = []
    var velocity: [Vector] = []
    var position: [Coordinate] = []
    
    var angularAcceleration: [Double] = []
    var angularVelocity: [Double] = []
    var rotation: [Double] = []
    
    var attackAngle: [Double] = []
    
    var error: [Double] = []
    var integralError: [Double] = []
    var derivativeError: [Double] = []
    
    var maxTime: Double = 0
    var interval: Double = 0.01 //0.02
    var loops: Int {
        return Int(maxTime / interval)
    }
    
    var UIthrust: [Double] {
        return thrust.map { $0.y }
    }
    var UIweight: [Double] {
        return weight.map { $0.y }
    }
    var UIdrag: [Double] {
        return drag.map { $0.y }
    }
    var UIacceleration: [Double] {
        return acceleration.map { $0.y }
    }
    var UIvelocity: [Double] {
        return velocity.map { $0.y }
    }
    var UIaltitude: [Double] {
        return position.map { $0.y }
    }
    
    var UXthrustAngle: [Double] {
        return thrust.map { $0.angle }
    }
    var UXthrustMagnitude: [Double] {
        return thrust.map { $0.magnitude }
    }
    var UXweightAngle: [Double] {
        return weight.map { $0.angle }
    }
    var UXweightMagnitude: [Double] {
        return weight.map { $0.magnitude }
    }
    var UXdragAngle: [Double] {
        return drag.map { $0.angle }
    }
    var UXdragMagnitude: [Double] {
        return drag.map { $0.magnitude }
    }
    var UXliftAngle: [Double] {
        return lift.map { $0.angle }
    }
    var UXliftMagnitude: [Double] {
        return lift.map { $0.magnitude }
    }
    var UXdisplacement: [Double] {
        return position.map { $0.x }
    }
    var UXaltitude: [Double] {
        return position.map { $0.y }
    }
    var UXvelocity: [Double] {
        return velocity.map { $0.magnitude }
    }
}
