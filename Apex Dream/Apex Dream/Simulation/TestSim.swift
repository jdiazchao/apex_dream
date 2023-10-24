//
//  TestSim.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 14/4/21.
//

import Foundation

func testSim(rocket: Rocket, environment: Conditions) -> TestData {
    
    var data: TestData = TestData()
    data.rocket = rocket
    
    let airDensity: Double = environment.airDensity
    let windVelocity: Vector = environment.wind
    let soundSpeed: Double = 340
    
    let averageSweepAngle: Double = 25
    let noseJointAngle: Double = 15
    
    var running: Bool = true
    var instance: Int = 0
    
    let maxMuchNumber: Double = 10
    let machNumberInterval: Double = 0.5
    
    for instance in  0...Int(maxMuchNumber / machNumberInterval) {
        let currentMachNumber = Double(instance) * data.machNumberInterval
        let flowVelocity: Double = currentMachNumber * soundSpeed
        let criticalReynoldsNumbers = 51 * pow(0.0024 / data.rocket.length, -1.039)
        let currentReynoldsNumber = (airDensity * flowVelocity * data.rocket.length) / (1.470 * pow(10, -5))
        let attackAngle: Double = 0.0
        
        //Normal Coefficient
        
        let crossflowDragFactor = 0.5
        let crossflowDragCoefficient = 1.2
        
        let normalCoefficient = (data.rocket.baseArea / data.rocket.referenceArea) * sin((2 * attackAngle) * Double.pi / 180) * cos((attackAngle / 2) * Double.pi / 180) + crossflowDragFactor * crossflowDragCoefficient * (data.rocket.planformArea / data.rocket.referenceArea) * pow(sin(attackAngle * Double.pi / 180), 2)
        
        data.MNliftCoefficient.append(normalCoefficient)
        
        //Base Drag
        
        var baseDragCoefficient: Double {
            if currentMachNumber < 1 {
                return 0.12 + 0.13 * pow(currentMachNumber, 2)
            } else {
                return 0.25 / currentMachNumber
            }
        }
        
        data.MNbaseContribution.append(baseDragCoefficient)
        
        //Pressure Drag
        
        var leadingPerpendicularFinPressure: Double {
            if currentMachNumber < 0.9 {
                return pow(1 - pow(currentMachNumber, 2), -0.417) - 1
            } else if currentMachNumber > 0.9 && currentMachNumber < 1 {
                return 1 - 1.785 * (currentMachNumber - 0.9)
            } else {
                return 1.214 - (0.502 / pow(currentMachNumber, 2)) + (0.1095 / pow(currentMachNumber, 4))
            }
        }
        
        let leadingFinPressure: Double = leadingPerpendicularFinPressure * pow(cos(averageSweepAngle * Double.pi / 180), 2)
        let trailingFinPressure: Double = baseDragCoefficient
        let finPressureCoefficient: Double = leadingFinPressure + trailingFinPressure
        
        let coneRatio: Double = atan((data.rocket.length / 2) / data.rocket.length) * 180 / Double.pi
        
        var conePressureCoefficient: Double {
            if currentMachNumber <= 1 {
                let startPoint = 0.8 * pow(sin(noseJointAngle * Double.pi / 180), 2)
                let startSlope = 0.0
                let finishPoint = sin(coneRatio * Double.pi / 180)
                let finishSlope = (4 / (1.4 + 1)) * (1 - 0.5 * finishPoint)
                
                return (finishSlope - startSlope) / 2 * pow(currentMachNumber, 2) + startPoint
            } else if currentMachNumber > 1 && currentMachNumber < 1.3 {
                return 1
            } else {
                return 2.1 * pow(sin(coneRatio * Double.pi / 180), 2) + 0.5 * (sin(coneRatio * Double.pi / 180) / sqrt(pow(currentMachNumber, 2) - 1))
            }
        }
        
        let boattailRatio: Double = 0
        let boattailArea: Double = 0
        
        var boattailPressureCoefficient: Double {
            var constant: Double {
                if boattailArea == 0 {
                    return 0
                } else {
                    return data.rocket.baseArea / boattailArea
                }
            }
            if boattailRatio < 1 {
                return constant
            } else if boattailRatio > 1 && boattailRatio < 3 {
                return constant * ((3 - boattailRatio) / 2)
            } else {
                return 0
            }
        }
        
        let pressureDrag = conePressureCoefficient + finPressureCoefficient + boattailPressureCoefficient
        
        data.MNpressureContribution.append(pressureDrag)
        
        //Frictional Drag
        
        var skinFrictionCoefficient: Double {
            var approximation: Double {
                if currentReynoldsNumber < pow(10, 4) {
                    return pow(1.48, -2)
                } else if currentReynoldsNumber > pow(10, 4) && currentReynoldsNumber < criticalReynoldsNumbers {
                    return 1 / pow(1.5 * log(currentReynoldsNumber) - 5.6, 2)
                } else {
                    return 0.032 * pow(0.00079 / data.rocket.length, 0.2)
                }
            }
            if flowVelocity.magnitude < soundSpeed {
                return approximation * (1 - (0.1 * pow(currentMachNumber, 2)))
            } else {
                return approximation * (approximation / pow(1 + (0.15 * pow(currentMachNumber, 2)), 0.58))
            }
        }
        
        var frictionDragCoefficient: Double {
            if data.rocket.averageChord != 0 {
                return skinFrictionCoefficient * ((1 + (1 / (2 * (data.rocket.length / data.rocket.diameter)))) * data.rocket.wettedBodyArea + (1 + ((2 * data.rocket.thickness) / data.rocket.averageChord)) * data.rocket.wettedFinsArea / data.rocket.baseArea)
            } else {
                return skinFrictionCoefficient * ((1 + (1 / (2 * (data.rocket.length / data.rocket.diameter)))) * data.rocket.wettedBodyArea / data.rocket.baseArea)
            }
        }
        
        data.MNfrictionContribution.append(frictionDragCoefficient)
        
        //Drag
        
        let dragCoefficient = frictionDragCoefficient + conePressureCoefficient + finPressureCoefficient + boattailPressureCoefficient + baseDragCoefficient
        let correctedDragCoefficient = dragCoefficient * pow(cos(attackAngle * Double.pi / 180), 2)
        
        data.MNdragCoefficient.append(correctedDragCoefficient)
        
        data.machNumber.append(currentMachNumber)
    }
    
    for instance in  0...data.attackAngleLoops {
        let currentMachNumber = 1.0
        let flowVelocity: Double = currentMachNumber * soundSpeed
        let criticalReynoldsNumbers = 51 * pow(0.0024 / data.rocket.length, -1.039)
        let currentReynoldsNumber = (airDensity * flowVelocity * data.rocket.length) / (1.470 * pow(10, -5))
        let currentAttackAngle: Double = Double(instance) * data.attackAngleInterval
        
        var correctedAttackAngle: Double {
            if currentAttackAngle > -90 && currentAttackAngle < 90 {
                return currentAttackAngle
            } else {
                return 180 - currentAttackAngle
            }
        }
        
        let areaCorrection: Double = (data.rocket.wettedBodyArea + data.rocket.wettedFinsArea) / data.rocket.referenceArea
        print("Area correction: \(areaCorrection)")
        
        //Normal Coefficient
        
        let crossflowDragFactor = 0.5
        let crossflowDragCoefficient = 1.2
        
        let normalCoefficient = (data.rocket.baseArea / data.rocket.referenceArea) * sin((2 * correctedAttackAngle) * Double.pi / 180) * cos((correctedAttackAngle / 2) * Double.pi / 180) + crossflowDragFactor * crossflowDragCoefficient * (data.rocket.planformArea / data.rocket.referenceArea) * pow(sin(correctedAttackAngle * Double.pi / 180), 2)
        
        data.AAliftCoefficient.append(normalCoefficient)
        
        //Base Drag
        
        var baseDragCoefficient: Double {
            if currentMachNumber < 1 {
                return 0.12 + 0.13 * pow(currentMachNumber, 2)
            } else {
                return 0.25 / currentMachNumber
            }
        }
        
        data.AAbaseContribution.append(baseDragCoefficient)
        
        //Pressure Drag
        
        var leadingPerpendicularFinPressure: Double {
            if currentMachNumber < 0.9 {
                return pow(1 - pow(currentMachNumber, 2), -0.417) - 1
            } else if currentMachNumber > 0.9 && currentMachNumber < 1 {
                return 1 - 1.785 * (currentMachNumber - 0.9)
            } else {
                return 1.214 - (0.502 / pow(currentMachNumber, 2)) + (0.1095 / pow(currentMachNumber, 4))
            }
        }
        
        let leadingFinPressure: Double = leadingPerpendicularFinPressure * pow(cos(averageSweepAngle * Double.pi / 180), 2)
        let trailingFinPressure: Double = baseDragCoefficient
        let finPressureCoefficient: Double = leadingFinPressure + trailingFinPressure
        
        let coneRatio: Double = atan((data.rocket.length / 2) / data.rocket.length) * 180 / Double.pi
        
        var conePressureCoefficient: Double {
            if currentMachNumber <= 1 {
                let startPoint = 0.8 * pow(sin(noseJointAngle * Double.pi / 180), 2)
                let startSlope = 0.0
                let finishPoint = sin(coneRatio * Double.pi / 180)
                let finishSlope = (4 / (1.4 + 1)) * (1 - 0.5 * finishPoint)
                
                return (finishSlope - startSlope) / 2 * pow(currentMachNumber, 2) + startPoint
            } else if currentMachNumber > 1 && currentMachNumber < 1.3 {
                return 1
            } else {
                return 2.1 * pow(sin(coneRatio * Double.pi / 180), 2) + 0.5 * (sin(coneRatio * Double.pi / 180) / sqrt(pow(currentMachNumber, 2) - 1))
            }
        }
        
        let boattailRatio: Double = 0
        let boattailArea: Double = 0
        
        var boattailPressureCoefficient: Double {
            var constant: Double {
                if boattailArea == 0 {
                    return 0
                } else {
                    return data.rocket.baseArea / boattailArea
                }
            }
            if boattailRatio < 1 {
                return constant
            } else if boattailRatio > 1 && boattailRatio < 3 {
                return constant * ((3 - boattailRatio) / 2)
            } else {
                return 0
            }
        }
        
        let pressureDrag = conePressureCoefficient + finPressureCoefficient + boattailPressureCoefficient
        
        data.AApressureContribution.append(pressureDrag)
        
        //Frictional Drag
        
        var skinFrictionCoefficient: Double {
            var approximation: Double {
                if currentReynoldsNumber < pow(10, 4) {
                    return pow(1.48, -2)
                } else if currentReynoldsNumber > pow(10, 4) && currentReynoldsNumber < criticalReynoldsNumbers {
                    return 1 / pow(1.5 * log(currentReynoldsNumber) - 5.6, 2)
                } else {
                    return 0.032 * pow(0.00079 / data.rocket.length, 0.2)
                }
            }
            if flowVelocity.magnitude < soundSpeed {
                return approximation * (1 - (0.1 * pow(currentMachNumber, 2)))
            } else {
                return approximation * (approximation / pow(1 + (0.15 * pow(currentMachNumber, 2)), 0.58))
            }
        }
        
        var frictionDragCoefficient: Double {
            if data.rocket.averageChord != 0 {
                return skinFrictionCoefficient * ((1 + (1 / (2 * (data.rocket.length / data.rocket.diameter)))) * data.rocket.wettedBodyArea + (1 + ((2 * data.rocket.thickness) / data.rocket.averageChord)) * data.rocket.wettedFinsArea / data.rocket.baseArea)
            } else {
                return skinFrictionCoefficient * ((1 + (1 / (2 * (data.rocket.length / data.rocket.diameter)))) * data.rocket.wettedBodyArea / data.rocket.baseArea)
            }
        }
        
        data.AAfrictionContribution.append(frictionDragCoefficient)
        
        //Drag
        
        let dragCoefficient = frictionDragCoefficient + conePressureCoefficient + finPressureCoefficient + boattailPressureCoefficient + baseDragCoefficient
        let correctedDragCoefficient = dragCoefficient * pow(cos(correctedAttackAngle * Double.pi / 180), 2)
        
        data.AAdragCoefficient.append(correctedDragCoefficient)
        
        data.attackAngle.append(currentAttackAngle)
    }
    
    return data
}
