//
//  Vector.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 31/3/21.
//

import Foundation

struct Vector {
    var magnitude: Double
    var angle: Double
    
    var opposite: Double {
        if angle >= 180 {
            return angle - 180
        } else {
            return angle + 180
        }
    }
    var perpendicular: Double {
        switch angle {
        case ...90:
            return 360 - (angle - 90)
        case 90...180:
            return angle + 90
        case 180...270:
            return angle - 90
        case 270...:
            return (angle + 90) - 360
        default:
            return angle + 90
        }
    }
    
    var x: Double {
        return magnitude * cos(angle * Double.pi / 180)
    }
    
    var y: Double {
        return magnitude * sin(angle * Double.pi / 180)
    }
    
    init() {
        self.magnitude = 0
        self.angle = 0
    }
    
    init(magnitude: Double, angle: Double) {
        self.magnitude = magnitude
        self.angle = angle
    }
    
    init(x: Double, y: Double) {
        self.magnitude = sqrt(pow(x.rounded(toPlaces: 3), 2) + pow(y.rounded(toPlaces: 3), 2))
        
        //print("x: \(x.rounded(toPlaces: 3)), y: \(y.rounded(toPlaces: 3))")
        //print(sqrt(pow(x.rounded(toPlaces: 3), 2) + pow(y.rounded(toPlaces: 3), 2)))
        //print(atan(y.rounded(toPlaces: 3) / x.rounded(toPlaces: 3)) * 180 / Double.pi)
        
        var error: Double {
            if x < 0 && y < 0 {
                return 180
            } else if x < 0 {
                return 180
            } else if y < 0 {
                return 360
            } else {
                return 0
            }
        }
        
        //print(error)
        
        let fuck = atan(y.rounded(toPlaces: 3) / x.rounded(toPlaces: 3)) * 180 / Double.pi
        
        //print("Angle: \(atan(y.rounded(toPlaces: 3) / x.rounded(toPlaces: 3)) * 180 / Double.pi + error)")
        
        self.angle = fuck + error
    }
    
}
