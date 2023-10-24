//
//  Rocket.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 23/3/21.
//

import Foundation

public struct Rocket: Codable, Identifiable, Equatable, Hashable {
    public var id: String = "custom"
    var name: String = "Custom"
    var manufacturer: String = ""
    
    var mass: Double = 0.0401
    
    var length: Double = 0.425
    var diameter: Double = 0.025
    
    var tipChord: Double = 0.05
    var rootChord: Double = 0.05
    var height: Double = 0.03
    var thickness: Double = 0.002
    var finsNumber: Int = 3
    
    var finArea: Double {
        return (tipChord + rootChord) / 2 * height
    }
    var averageChord: Double {
        return (tipChord + rootChord) / 2
    }
    var wettedBodyArea: Double {
        return Double.pi * self.length * self.diameter
    }
    var wettedFinsArea: Double {
        return self.finArea * 2 * Double(self.finsNumber)
    }
    var baseArea: Double {
        return Double.pi * pow(diameter / 2, 2)
    }
    var referenceArea: Double {
        return diameter * length + finArea * Double((finsNumber / 2))
    }
    var planformArea: Double {
        return diameter * length + finArea * Double((finsNumber / 2))
    }
    
    var gravityCentre: Double = 0.216
    var pressureCentre: Double = 0.32
    var thrustCentre: Double =  0.425
    
    var dragArea: Double = 0.00049
    var dragCoefficient: Double = 0.64
    
    var liftArea: Double = 0.00121
    var liftCoefficient: Double = 0.2
    
    var rotationalInertia: Double {
        return (1 / 12) * mass * (3 * pow(diameter / 2, 2) + pow(length, 2))
    }
    
    var tvc: Bool = false
    var kp: Double = 0.0
    var ki: Double = 0.0
    var kd: Double = 0.0
    
    var motorType: String = "d9"
    var motorQuantity: Int = 1
    
    var motor: Motor {
        let motors: [Motor] = Bundle.main.decode(Array<Motor>.self, from: "motors.json")
        return motors.first(where: { $0.id == motorType }) ?? motors[0]
    }
}
