//
//  FlightSim.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 25/7/21.
//

import Foundation

func flightSim(rocket: Rocket, environment: Conditions) -> FlightData {
    
    var data: FlightData = FlightData()
    data.rocket = rocket
    
    let airDensity: Double = environment.airDensity
    let windVelocity: Vector = environment.wind
    let soundSpeed: Double = 340
    
    let averageSweepAngle: Double = 25
    let noseJointAngle: Double = 0.1
    
    var running: Bool = true
    var instance: Int = 0
    
    while running {
        let time = Double(instance) * data.interval
        
        print()
        print("T-\(time)")
        
        data.time.append(time)
        
        //Temporary Values
        
        var temporaryVelocity: Vector {
            if data.velocity.count > 0 {
                return data.velocity[instance - 1]
            } else {
                return Vector()
            }
        }
        
        var temporaryRotation: Double {
            if data.rotation.count > 0 {
                return Double(data.rotation[data.rotation.count - 1])
            } else {
                return 90
            }
        }
        
        //PID
        
        var kp: Double {
            if data.rocket.tvc {
                return data.rocket.kp
            } else {
                return 0
            }
        }
        var ki: Double {
            if data.rocket.tvc {
                return data.rocket.ki
            } else {
                return 0
            }
        }
        var kd: Double {
            if data.rocket.tvc {
                return data.rocket.kd
            } else {
                return 0
            }
        }
        
        let error = 90 - temporaryRotation
        data.error.append(error)
        
        var integralError: Double {
            if instance > 0 {
                return data.integralError[instance - 1] + (data.error[instance] * data.interval)
            } else {
                return 0
            }
        }
        data.integralError.append(integralError)
        
        var derivativeError: Double {
            if instance > 0 {
                return (data.error[instance] - data.error[instance - 1]) / data.interval
            } else {
                return 0
            }
        }
        data.derivativeError.append(derivativeError)
        
        let gp = data.error[instance] * kp
        let gi = data.integralError[instance] * ki
        let gd = data.derivativeError[instance] * kd
        var correction: Double {
            var pid = gp + gi + gd
            if pid > 10 {
                pid = 10
            }
            if pid < -10 {
                pid = -10
            }
            return pid
        }
        
        //Thrust
        
        let proximateThrust = data.rocket.motor.time.lastIndex(where: { $0 <= time } ) ?? 0
        
        var currentThrust: Vector = Vector(magnitude: 0, angle: 0)
        
        if proximateThrust < data.rocket.motor.time.count - 1 {
            let thrustSlope = (data.rocket.motor.thrust[proximateThrust + 1] - data.rocket.motor.thrust[proximateThrust]) / (data.rocket.motor.time[proximateThrust + 1] - data.rocket.motor.time[proximateThrust])
            let thrustIntercept = data.rocket.motor.thrust[proximateThrust] - (thrustSlope * data.rocket.motor.time[proximateThrust])
            
            let thrustMagnitude = ((thrustSlope * time) + thrustIntercept) * Double(data.rocket.motorQuantity)
            currentThrust = Vector(magnitude: thrustMagnitude, angle: temporaryRotation - correction)
        }
        
        data.thrust.append(currentThrust)
        
        //Thrust Torque
        
        let thrustTorque = currentThrust.magnitude * (data.rocket.gravityCentre - data.rocket.length) * sin((correction) * Double.pi / 180) * -1
        
        //Flow
        
        let relativeVelocity: Vector = Vector(magnitude: temporaryVelocity.magnitude, angle: temporaryVelocity.opposite)
        var flowVelocity: Vector {
            if windVelocity.magnitude > 0 {
                return Vector(x: windVelocity.x + relativeVelocity.x, y: windVelocity.y + relativeVelocity.y)
            } else {
                return relativeVelocity
            }
        }
        
        var currentAttackAngle = flowVelocity.opposite - temporaryRotation
        
        if currentAttackAngle > 180 {
            currentAttackAngle = -180 + (currentAttackAngle - 180)
        }
        if currentAttackAngle < -180 {
            currentAttackAngle = 180 + (currentAttackAngle + 180)
        }
        
        data.attackAngle.append(currentAttackAngle)
        
        var correctedAttackAngle: Double {
            if currentAttackAngle > -90 && currentAttackAngle < 90 {
                return currentAttackAngle
            } else {
                return 180 - currentAttackAngle
            }
        }
        
        //Mach Number
        
        let currentMachNumber = flowVelocity.magnitude / soundSpeed
        
        //Reynolds Number
        
        let criticalReynoldsNumbers = 51 * pow(0.0024 / data.rocket.length, -1.039)
        let currentReynoldsNumber = (airDensity * flowVelocity.magnitude * data.rocket.length) / (1.470 * pow(10, -5))
        
        //Normal Coefficient
        
        let crossflowDragFactor = 0.5
        let crossflowDragCoefficient = 1.2
        
        let normalCoefficient = (data.rocket.baseArea / data.rocket.referenceArea) * sin((2 * correctedAttackAngle) * Double.pi / 180) * cos((correctedAttackAngle / 2) * Double.pi / 180) + crossflowDragFactor * crossflowDragCoefficient * (data.rocket.planformArea / data.rocket.referenceArea) * pow(sin(correctedAttackAngle * Double.pi / 180), 2)
         
        //Base Drag
        
        var baseDragCoefficient: Double {
            if currentMachNumber < 1 {
                return 0.12 + 0.13 * pow(currentMachNumber, 2)
            } else {
                return 0.25 / currentMachNumber
            }
        }
        
        //Pressure Drag // To complete
        
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
        
        print("Frictional Drag Coefficient: \(frictionDragCoefficient)")
        
        //Interference Drag
        
        var interferenceDragCoefficient: Double {
            if data.rocket.averageChord != 0 {
                return skinFrictionCoefficient * (1 + (2 * (data.rocket.thickness / data.rocket.averageChord))) * (data.rocket.averageChord / data.rocket.wettedBodyArea) * (data.rocket.diameter * Double(data.rocket.finsNumber))
            } else {
                return 0
            }
        }
        
        print("Interference Drag Coefficient: \(interferenceDragCoefficient)")
        
        //Drag
        
        let dragCoefficient = frictionDragCoefficient + conePressureCoefficient + finPressureCoefficient + boattailPressureCoefficient + baseDragCoefficient
        let correctedDragCoefficient = dragCoefficient * pow(cos(correctedAttackAngle * Double.pi / 180), 2)
        //let dragCoefficient = -0.00004 * pow(abs(currentAttackAngle), 2) + 0.0077 * abs(currentAttackAngle) + 0.6831
        let dragMagnitude = dragCoefficient * airDensity * pow(flowVelocity.magnitude, 2) * data.rocket.dragArea / 2
        //let currentDrag: Vector = Vector(magnitude: dragMagnitude, angle: flowVelocity.angle)
        let currentDrag: Vector = Vector(magnitude: dragMagnitude, angle: temporaryVelocity.opposite)
        
        print("Drag Coefficient: \(dragCoefficient)")
        
        data.drag.append(currentDrag)
        
        //Drag Torque
        
        var constant: Int {
            if currentAttackAngle >= 0 {
                return -1
            } else {
                return 1
            }
        }
        
        let dragTorque = currentDrag.magnitude * (data.rocket.gravityCentre - data.rocket.pressureCentre) * abs(sin((currentAttackAngle) * Double.pi / 180)) * Double(constant)
        
        print("Drag Torque: \(dragTorque)")
        
        //Lift
        
        let liftCoefficient = 1.1 * (data.rocket.dragArea / data.rocket.liftArea) * pow(sin(currentAttackAngle), 2)
        let liftMagnitude = normalCoefficient * airDensity * pow(flowVelocity.magnitude, 2) * data.rocket.liftArea / 2
        //let currentLift: Vector = Vector(magnitude: liftMagnitude, angle: perpendicularFlow(flow: flowVelocity.angle, attack: currentAttackAngle))
        let currentLift: Vector = Vector(magnitude: liftMagnitude, angle: perpendicularFlow(flow: temporaryVelocity.angle, attack: currentAttackAngle))
        data.lift.append(currentLift)
        
        //Lift Torque
        
        let liftTorque = currentLift.magnitude * (data.rocket.gravityCentre - data.rocket.pressureCentre) * abs(cos((currentAttackAngle) * Double.pi / 180)) * Double(constant)
        
        //Weight
        
        let propellantSlope = ((data.rocket.motor.totalMass - data.rocket.motor.propellantMass) - data.rocket.motor.totalMass) / (data.rocket.motor.time.max() ?? 0)
        let propellantIntercept = data.rocket.motor.totalMass
        var propellantMass: Double {
            if time > data.rocket.motor.time.max() ?? 0 {
                return data.rocket.motor.totalMass - data.rocket.motor.propellantMass
            } else {
                return propellantSlope * time + propellantIntercept
            }
        }
        
        let currentMass = data.rocket.mass + propellantMass
        let weightMagnitude = currentMass * 9.81
        let currentWeight: Vector = Vector(magnitude: weightMagnitude, angle: 270)
        
        data.weight.append(currentWeight)
        
        //Normal
        
        var normal: Vector {
            if instance > 0 {
                if data.position[instance - 1].y <= 0 {
                    return Vector(magnitude: weightMagnitude, angle: 90)
                } else {
                    return Vector(magnitude: 0, angle: 0)
                }
            } else {
                return Vector(magnitude: weightMagnitude, angle: 90)
            }
        }
        
        //Translational Acceleration
        
        let accelerationX = (currentThrust.x + currentDrag.x + currentLift.x + currentWeight.x + normal.x) / currentMass
        let accelerationY = (currentThrust.y + currentDrag.y + currentLift.y + currentWeight.y + normal.y) / currentMass
        let currentAcceleration: Vector = Vector(x: accelerationX, y: accelerationY)
        
        data.acceleration.append(currentAcceleration)
        
        //Angular Acceleration
        
        let totalTorque = dragTorque + liftTorque + thrustTorque
        
        let currentAngularAcceleration = totalTorque / data.rocket.rotationalInertia
        
        data.angularAcceleration.append(currentAngularAcceleration)
        
        //Angular Velocity
        
        if instance > 0 {
            let currentAcceleration = data.angularAcceleration[instance]
            let previousAcceleration = data.angularAcceleration[instance - 1]
            let previousVelocity = data.angularVelocity[instance - 1]
            let averageAcceleration = previousAcceleration + currentAcceleration / 2
            
            let currentVelocity = previousVelocity + averageAcceleration * data.interval
            
            data.angularVelocity.append(currentVelocity)
            
            let previousRotation = data.rotation[instance - 1]
            let newRotation = (currentVelocity + previousVelocity) * data.interval / 2
            
            let currentRotation = previousRotation + newRotation
            
            if currentRotation >= 360 {
                data.rotation.append(currentRotation - 360)
            } else if currentRotation < 0 {
                data.rotation.append(currentRotation + 360)
            } else {
                data.rotation.append(currentRotation)
            }
        } else {
            let currentAngularVelocity: Double = 0
            data.angularVelocity.append(currentAngularVelocity)
            
            data.rotation.append(90)
        }
        
        //Velocity
        
        if instance > 0 {
            let currentAcceleration = data.acceleration[instance]
            let previousAcceleration = data.acceleration[instance - 1]
            let previousVelocity = data.velocity[instance - 1]
            
            let averageAcceleration: Vector = Vector(x: (previousAcceleration.x + currentAcceleration.x) / 2, y: (previousAcceleration.y + currentAcceleration.y) / 2)
            
            let currentVelocity: Vector = Vector(x: previousVelocity.x + averageAcceleration.x * data.interval, y: previousVelocity.y + averageAcceleration.y * data.interval)
            
            data.velocity.append(currentVelocity)
            
            //Position
            
            let previousAltitude = data.position[instance - 1].y
            let newAltitude = (currentVelocity.y + previousVelocity.y) * data.interval / 2
            var currentAltitude = previousAltitude + newAltitude
            if currentAltitude < 0 {
                currentAltitude = 0
            }
            
            let previousDisplacement = data.position[instance - 1].x
            let newDisplacement = (currentVelocity.x + previousVelocity.x) * data.interval / 2
            let currentDisplacement = previousDisplacement + newDisplacement
            
            let currentPosition: Coordinate = Coordinate(x: currentDisplacement, y: currentAltitude)
            
            data.position.append(currentPosition)
            
        } else {
            let currentVelocity: Vector = Vector(magnitude: 0, angle: 0)
            data.velocity.append(currentVelocity)
            
            let currentPosition: Coordinate = Coordinate(x: 0, y: 0)
            data.position.append(currentPosition)
        }
        
        if instance > 100 && data.position[instance].y <= 0 {
            data.maxTime = time
            running = false
        }
        
        instance += 1
    }
    
    return data
}

func perpendicularFlow2(flow: Double, attack: Double) -> Double {
    var angle: Double = 0
    
    switch attack {
    case ...(-90):
        angle = flow + 90
    case -90...0:
        angle = flow - 90
    case 0...90:
        angle = flow + 90
    case 90...:
        angle = flow - 90
    default:
        let random = Int.random(in: 0...1)
        if random == 0 {
            angle = flow + 90
        } else {
            angle = flow - 90
        }
    }
    
    if angle >= 360 {
        angle = angle - 360
    }
    if angle < 0 {
        angle = angle + 360
    }
    
    return angle
}
