//
//  TestData.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 14/4/21.
//

import Foundation

struct TestData {
    var id: String = "trial"
    var rocket: Rocket = Rocket()
    
    var machNumber: [Double] = []
    var attackAngle: [Double] = []
    
    var MNliftCoefficient: [Double] = []
    var MNbaseContribution: [Double] = []
    var MNpressureContribution: [Double] = []
    var MNfrictionContribution: [Double] = []
    var MNdragCoefficient: [Double] = []
    
    var AAliftCoefficient: [Double] = []
    var AAbaseContribution: [Double] = []
    var AApressureContribution: [Double] = []
    var AAfrictionContribution: [Double] = []
    var AAdragCoefficient: [Double] = []
    
    var maxMachNumber: Double = 10
    var machNumberInterval: Double = 0.5
    var machNumberLoops: Int {
        return Int(maxMachNumber / machNumberInterval)
    }
    
    var maxAttackAngle: Double = 180
    var attackAngleInterval: Double = 5
    var attackAngleLoops: Int {
        return Int(maxAttackAngle / attackAngleInterval)
    }
}
