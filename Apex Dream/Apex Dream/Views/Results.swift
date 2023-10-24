//
//  Results.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 23/3/21.
//

import SwiftUI

/*struct YepResults: View {
    var data: FlightData
    
    @State var on: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                HStack(spacing: 20) {
                    HStack {
                        Image(systemName: "square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.yellow)
                            .frame(width: 10, height: 10)
                        Text("Thrust")
                    }
                    HStack {
                        Image(systemName: "square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.orange)
                            .frame(width: 10, height: 10)
                        Text("Drag")
                    }
                    HStack {
                        Image(systemName: "square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.red)
                            .frame(width: 10, height: 10)
                        Text("Weight")
                    }
                }
                ZStack {
                    Color.white
                        .aspectRatio(16/9, contentMode: .fit)
                        .padding()
                    LineGraph(dataPoints: data.UIthrust, maxValue: data.UIthrust.max() ?? 0)
                        .trim(to: on ? 1 : 0)
                        .stroke(Color.yellow, lineWidth: 4)
                        .aspectRatio(16/9, contentMode: .fit)
                        .border(Color.black, width: 1)
                        .clipped()
                        .padding()
                    LineGraph(dataPoints: data.UIdrag, maxValue: data.UIthrust.max() ?? 0)
                        .trim(to: on ? 1 : 0)
                        .stroke(Color.orange, lineWidth: 4)
                        .aspectRatio(16/9, contentMode: .fit)
                        .border(Color.black, width: 1)
                        .clipped()
                        .padding()
                    LineGraph(dataPoints: data.UIweight, maxValue: data.UIthrust.max() ?? 0)
                        .trim(to: on ? 1 : 0)
                        .stroke(Color.red, lineWidth: 4)
                        .aspectRatio(16/9, contentMode: .fit)
                        .border(Color.black, width: 1)
                        .clipped()
                        .padding()
                }
                HStack {
                    Text("Peak thrust: \(String(format: "%.1f", data.UIthrust.max() ?? 0)) N")
                        .animation(nil)
                }
            }
            VStack {
                HStack(spacing: 20) {
                    HStack {
                        Image(systemName: "square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(.cyan))
                            .frame(width: 10, height: 10)
                        Text("Acceleration")
                    }
                    HStack {
                        Image(systemName: "square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(.blue))
                            .frame(width: 10, height: 10)
                        Text("Velocity")
                    }
                }
                ZStack {
                    Color.white
                        .aspectRatio(16/9, contentMode: .fit)
                        .padding()
                    LineGraph(dataPoints: data.UIacceleration, maxValue: data.UIvelocity.max() ?? 0)
                        .trim(to: on ? 1 : 0)
                        .stroke(Color(.cyan), lineWidth: 4)
                        .aspectRatio(16/9, contentMode: .fit)
                        .border(Color.black, width: 1)
                        .clipped()
                        .padding()
                    LineGraph(dataPoints: data.UIvelocity, maxValue: data.UIvelocity.max() ?? 0 )
                        .trim(to: on ? 1 : 0)
                        .stroke(Color(.blue), lineWidth: 4)
                        .aspectRatio(16/9, contentMode: .fit)
                        .border(Color.black, width: 1)
                        .clipped()
                        .padding()
                }
                HStack {
                    Text("Max. velocity: \(String(format: "%.2f", data.UIvelocity.max() ?? 0)) m/s")
                        .animation(nil)
                }
            }
            VStack {
                HStack(spacing: 20) {
                    HStack {
                        Image(systemName: "square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.purple)
                            .frame(width: 10, height: 10)
                        Text("Altitude")
                    }
                }
                LineGraph(dataPoints: data.UIaltitude, maxValue: data.UIaltitude.max() ?? 0)
                    .trim(to: on ? 1 : 0)
                    .stroke(Color.purple, lineWidth: 4)
                    .aspectRatio(16/9, contentMode: .fit)
                    .border(Color.black, width: 1)
                    .background(Color.white)
                    .clipped()
                    .padding()
                HStack {
                    Text("Max. altitude: \(String(format: "%.2f", data.UIaltitude.max() ?? 0)) m")
                        .animation(nil)
                }
            }
            /*VStack {
                HStack(spacing: 20) {
                    HStack {
                        Image(systemName: "square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.green)
                            .frame(width: 10, height: 10)
                        Text("Rotation")
                    }
                }
                LineGraph(dataPoints: data.rotation, maxValue: data.rotation.max() ?? 0)
                    .trim(to: on ? 1 : 0)
                    .stroke(Color.green, lineWidth: 4)
                    .aspectRatio(16/9, contentMode: .fit)
                    .border(Color.black, width: 1)
                    .background(Color.white)
                    .clipped()
                    .padding()
                HStack {
                    Text("Angle range: \(String(format: "%.2f", data.rotation.min() ?? 0)) - \(String(format: "%.2f", data.rotation.max() ?? 0)) º")
                        .animation(nil)
                }
            }*/
        }
        .onAppear {
            on.toggle()
        }
    }
}*/

struct TestResults: View {
    var data: TestData
    
    @State var pickedDependentVariables: [DependentVariable] = [.dragCoefficient]
    @State var pickedIndependentVariable: IndependentVariable = .machNumber
    
    var body: some View {
        let firstDependentVariable = Binding<DependentVariable>(
            get: {
                self.pickedDependentVariables[0]
            },
            set: {
                let input = $0
                self.pickedDependentVariables.remove(at: 0)
                self.pickedDependentVariables.insert(input, at: 0)
            }
        )
        let independentVariable = Binding<IndependentVariable>(
            get: {
                self.pickedIndependentVariable
            },
            set: {
                let input = $0
                self.pickedIndependentVariable = input
            }
        )
        
        return ScrollView() {
            VStack() {
                HStack {
                    Rectangle()
                        .foregroundColor(Color.blue)
                        .frame(width: 20, height: 5)
                    ForEach(pickedDependentVariables, id: \.self) { pickedVariable in
                        Picker("", selection: firstDependentVariable) {
                            ForEach(DependentVariable.allCases, id: \.self) { variable in
                                Text(variable.name()).tag(variable)
                                    .font(.system(size: 15))
                            }
                        }
                        .frame(width: 200)
                        Text(pickedVariable.units())
                    }
                }
                Graph(
                    xData: pickedIndependentVariable.data(source: data),
                    yData: pickedDependentVariables[0].data(source: data, independent: pickedIndependentVariable),
                    width: 1000, height: 500, spacing: 50
                )
                HStack {
                    Picker("", selection: independentVariable) {
                        ForEach(IndependentVariable.allCases, id: \.self) { variable in
                            Text(variable.name()).tag(variable)
                                .font(.system(size: 15))
                        }
                    }
                    .frame(width: 200)
                    Text(pickedIndependentVariable.units())
                }
                Spacer()
            }
            .padding()
        }
    }
    
    enum DependentVariable: CaseIterable {
        case liftCoefficient, dragCoefficient, baseContribution, pressureContribution, frictionContribution
        
        func data(source: TestData, independent: IndependentVariable) -> [Double] {
            switch self {
            case .liftCoefficient:
                switch independent {
                case .machNumber:
                    return source.MNliftCoefficient
                case .attackAngle:
                    return source.AAliftCoefficient
                }
            case .dragCoefficient:
                switch independent {
                case .machNumber:
                    return source.MNdragCoefficient
                case .attackAngle:
                    return source.AAdragCoefficient
                }
            case .baseContribution:
                switch independent {
                case .machNumber:
                    return source.MNbaseContribution
                case .attackAngle:
                    return source.AAbaseContribution
                }
            case .pressureContribution:
                switch independent {
                case .machNumber:
                    return source.MNpressureContribution
                case .attackAngle:
                    return source.AApressureContribution
                }
            case .frictionContribution:
                switch independent {
                case .machNumber:
                    return source.MNfrictionContribution
                case .attackAngle:
                    return source.AAfrictionContribution
                }
            }
        }
        
        func name() -> String {
            switch self {
            case .liftCoefficient:
                return "Lift Coefficient"
            case .dragCoefficient:
                return "Drag Coefficient"
            case .baseContribution:
                return "Base Contribution"
            case .pressureContribution:
                return "Presure Contribution"
            case .frictionContribution:
                return "Friction Contribution"
            }
        }
        
        func units() -> String {
            switch self {
            case .liftCoefficient:
                return ""
            case .dragCoefficient:
                return ""
            case .baseContribution:
                return ""
            case .pressureContribution:
                return ""
            case .frictionContribution:
                return ""
            }
        }
    }
    
    enum IndependentVariable: CaseIterable {
        case machNumber, attackAngle
        
        func data(source: TestData) -> [Double] {
            switch self {
            case .machNumber:
                return source.machNumber
            case .attackAngle:
                return source.attackAngle
            }
        }
        
        func name() -> String {
            switch self {
            case .machNumber:
                return "Mach Number"
            case .attackAngle:
                return "Angle of Attack"
            }
        }
        
        func units() -> String {
            switch self {
            case .machNumber:
                return ""
            case .attackAngle:
                return "º"
            }
        }
    }
}

struct FlightResults: View {
    var data: FlightData
    
    @State var pickedVariables: [Variable] = [.thrust]
    
    var body: some View {
        let firstVariable = Binding<Variable>(
            get: {
                self.pickedVariables[0]
            },
            set: {
                let input = $0
                self.pickedVariables.remove(at: 0)
                self.pickedVariables.insert(input, at: 0)
            }
        )
        
        return ScrollView() {
            VStack() {
                HStack {
                    Rectangle()
                        .foregroundColor(Color.blue)
                        .frame(width: 20, height: 5)
                    ForEach(pickedVariables, id: \.self) { pickedVariable in
                        Picker("", selection: firstVariable) {
                            ForEach(Variable.allCases, id: \.self) { variable in
                                Text(variable.name()).tag(variable)
                                    .font(.system(size: 15))
                            }
                        }
                        .frame(width: 200)
                        Text(pickedVariable.units())
                    }
                }
                Graph(
                    xData: data.time,
                    yData: pickedVariables[0].data(data: data),
                    width: 1000, height: 500, spacing: 50
                )
                Spacer()
            }
            .padding()
        }
    }
    
    enum Variable: CaseIterable {
        case thrust, weight, drag, lift, acceleration, velocity, altitude, angularAcceleration, angularVelocity, rotation, attackAngle, error
        
        func data(data: FlightData) -> [Double] {
            switch self {
            case .thrust:
                return data.thrust.map { $0.magnitude }
            case .weight:
                return data.weight.map { $0.magnitude }
            case .drag:
                return data.drag.map { $0.magnitude }
            case .lift:
                return data.lift.map { $0.magnitude }
            case .acceleration:
                return data.acceleration.map { $0.magnitude }
            case .velocity:
                return data.velocity.map { $0.magnitude }
            case .altitude:
                return data.position.map { $0.y }
            case .angularAcceleration:
                return data.angularAcceleration.map { $0.magnitude }
            case .angularVelocity:
                return data.angularVelocity.map { $0.magnitude }
            case .rotation:
                return data.rotation
            case .attackAngle:
                return data.attackAngle
            case .error:
                return data.error
            }
        }
        
        func name() -> String {
            switch self {
            case .thrust:
                return "Thrust"
            case .weight:
                return "Weight"
            case .drag:
                return "Drag"
            case .lift:
                return "Lift"
            case .acceleration:
                return "Linear Acceleration"
            case .velocity:
                return "Linear Velocity"
            case .altitude:
                return "Altitude"
            case .angularAcceleration:
                return "Angular Acceleration"
            case .angularVelocity:
                return "Angular Velocity"
            case .rotation:
                return "Rotation"
            case .attackAngle:
                return "Angle of Attack"
            case .error:
                return "Error"
            }
        }
        
        func units() -> String {
            switch self {
            case .thrust:
                return "N"
            case .weight:
                return "N"
            case .drag:
                return "N"
            case .lift:
                return "N"
            case .acceleration:
                return "m/s\u{00B2}"
            case .velocity:
                return "m/s"
            case .altitude:
                return "m"
            case .angularAcceleration:
                return "º/s\u{00B2}"
            case .angularVelocity:
                return "º/s"
            case .rotation:
                return "º"
            case .attackAngle:
                return "º"
            case .error:
                return "º"
            }
        }
    }
}
