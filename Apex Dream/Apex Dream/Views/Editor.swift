//
//  Editor.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 23/3/21.
//

import SwiftUI

struct RocketEditor: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        let mass = Binding<String>(
                    get: {
                        String(self.env.current.mass)
                    },
                    set: {
                        self.env.current.mass = Double($0) ?? 0
                    }
                )
        let gravityCentre = Binding<String>(
                    get: {
                        String(self.env.current.gravityCentre)
                    },
                    set: {
                        self.env.current.gravityCentre = Double($0) ?? 0
                    }
                )
        let pressureCentre = Binding<String>(
                    get: {
                        String(self.env.current.pressureCentre)
                    },
                    set: {
                        self.env.current.pressureCentre = Double($0) ?? 0
                    }
                )
        let thrustCentre = Binding<String>(
                    get: {
                        String(self.env.current.thrustCentre)
                    },
                    set: {
                        self.env.current.thrustCentre = Double($0) ?? 0
                    }
                )
        let dragArea = Binding<String>(
                    get: {
                        String(self.env.current.dragArea)
                    },
                    set: {
                        self.env.current.dragArea = Double($0) ?? 0
                    }
                )
        let dragCoefficient = Binding<String>(
                    get: {
                        String(self.env.current.dragCoefficient)
                    },
                    set: {
                        self.env.current.dragCoefficient = Double($0) ?? 0
                    }
                )
        let liftArea = Binding<String>(
                    get: {
                        String(self.env.current.liftArea)
                    },
                    set: {
                        self.env.current.liftArea = Double($0) ?? 0
                    }
                )
        let liftCoefficient = Binding<String>(
                    get: {
                        String(self.env.current.liftCoefficient)
                    },
                    set: {
                        self.env.current.liftCoefficient = Double($0) ?? 0
                    }
                )
        let tvc = Binding<Bool>(
                    get: {
                        self.env.current.tvc
                    },
                    set: {
                        self.env.current.tvc = $0
                    }
                )
        let kp = Binding<String>(
                    get: {
                        String(self.env.current.kp)
                    },
                    set: {
                        self.env.current.kp = Double($0) ?? 0
                    }
                )
        let ki = Binding<String>(
                    get: {
                        String(self.env.current.ki)
                    },
                    set: {
                        self.env.current.ki = Double($0) ?? 0
                    }
                )
        let kd = Binding<String>(
                    get: {
                        String(self.env.current.kd)
                    },
                    set: {
                        self.env.current.kd = Double($0) ?? 0
                    }
                )
        let motor = Binding<Motor>(
                    get: {
                        self.env.current.motor
                    },
                    set: {
                        self.env.current.motorType = $0.id
                    }
                )
        let quantity = Binding<Int>(
                    get: {
                        self.env.current.motorQuantity
                    },
                    set: {
                        self.env.current.motorQuantity = $0
                    }
                )
        
        return ZStack {
            Color.white
            
            HStack {
                Image(env.current.id)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .opacity(0.5)
                    .rotationEffect(.degrees(-67.5))
                
            }
            .offset(x: 200, y: 0)
            
            Spacer()
            HStack {
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            if env.selected > 0 {
                                env.selected -= 1
                                if env.selected == 0 {
                                    env.current = env.memory
                                } else {
                                    if env.current.id == "custom" {
                                        env.memory = env.current
                                    }
                                    env.current = env.rockets[env.selected]
                                }
                            }
                        }) {
                            Image(systemName: "arrowtriangle.left.fill")
                        }
                        
                        HStack(spacing: 0) {
                            Text(env.current.name)
                                .bold()
                            if !env.current.manufacturer.isEmpty {
                                Text(" by \(env.current.manufacturer)")
                                    .italic()
                            }
                        }
                        
                        Button(action: {
                            if env.selected < env.rockets.count - 1 {
                                env.selected += 1
                                if env.selected == 0 {
                                    env.current = env.memory
                                } else {
                                    if env.current.id == "custom" {
                                        env.memory = env.current
                                    }
                                    env.current = env.rockets[env.selected]
                                }
                            }
                        }) {
                            Image(systemName: "arrowtriangle.right.fill")
                        }
                    }
                    
                    Spacer()
                        .frame(height: 25)
                    
                    HStack {
                        Text("Mass (kg):")
                        TextField("", text: mass)
                    }.aspectRatio(17, contentMode: .fit)
                    HStack {
                        Text("CG:")
                        TextField("Gravity Centre", text: gravityCentre)
                        Text("CP:")
                        TextField("Pressure Centre", text: pressureCentre)
                        Group {
                            Text("CT:")
                            TextField("Thrust Centre", text: thrustCentre)
                        }
                        .opacity(env.current.tvc ? 1 : 0.5)
                        .disabled(!env.current.tvc)
                    }.aspectRatio(17, contentMode: .fit)
                    HStack {
                        Text("Drag  |")
                        Text("Area (m^2):")
                        TextField("Drag Area", text: dragArea)
                        Text("Coefficient:")
                        TextField("Drag Coefficient", text: dragCoefficient)
                            .aspectRatio(2, contentMode: .fit)
                    }.aspectRatio(17, contentMode: .fit)
                    HStack {
                        Text("Lift  |")
                        Text("Area (m^2):")
                        TextField("Lift Area", text: liftArea)
                        Text("Coefficient:")
                        TextField("Lift Coefficient", text: liftCoefficient)
                            .aspectRatio(2, contentMode: .fit)
                    }.aspectRatio(17, contentMode: .fit)
                    HStack {
                        Toggle(isOn: tvc) {
                            Text("TVC  |")
                        }
                        Group {
                            Text("KP:")
                            TextField("", text: kp)
                            Text("KI:")
                            TextField("", text: ki)
                            Text("KD:")
                            TextField("", text: kd)
                        }
                        .opacity(env.current.tvc ? 1 : 0.5)
                        .disabled(!env.current.tvc)
                    }.aspectRatio(17, contentMode: .fit)
                    HStack {
                        Text("Motor:")
                        Picker("", selection: motor) {
                            ForEach(env.motors, id: \.self) { motor in
                                Text(motor.name).tag(motor)
                            }
                        }
                        Stepper("x\(env.current.motorQuantity)", value: quantity, in: 1...5)
                    }.aspectRatio(17, contentMode: .fit)
                }
                Spacer()
            }
            .padding()
        }
        //.frame(width: 1000, height: 400, alignment: .center)
    }
}

struct RocketEditor_Previews: PreviewProvider {
    static var previews: some View {
        RocketEditor()
    }
}

struct RocketPicker: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    @State var search: String = ""
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                TextField("Search", text: $search)
                    .padding()
                    .padding(.bottom, -5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(VisualEffectView())
                List(env.rockets) { rocket in
                    VStack(alignment: .leading) {
                        Text(rocket.name)
                            .bold()
                        if !rocket.manufacturer.isEmpty {
                            Text("by \(rocket.manufacturer)")
                                //.italic()
                        }
                        Divider()
                    }
                    .opacity(env.current.id == rocket.id ? 0.6 : 1)
                    .onTapGesture {
                        if env.current.id != rocket.id {
                            env.current = rocket
                        }
                    }
                }
                .listStyle(SidebarListStyle())
            }
            .frame(width: 250)
            ZStack {
                Color.white
                
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(env.current.name)
                                .font(.system(size: 50))
                                .bold()
                            if !env.current.manufacturer.isEmpty {
                                Text("by \(env.current.manufacturer)")
                                    .font(.system(size: 20))
                                    .italic()
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                    .padding(.bottom, 15)
                    Divider()
                    Editor()
                }
            }
        }
    }
}

struct Editor: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        
        let length = Binding<String>(
                    get: {
                        String(self.env.current.length)
                    },
                    set: {
                        self.env.current.length = Double($0) ?? 0
                    }
                )
        let diameter = Binding<String>(
                    get: {
                        String(self.env.current.diameter)
                    },
                    set: {
                        self.env.current.diameter = Double($0) ?? 0
                    }
                )
        let tipChord = Binding<String>(
                    get: {
                        String(self.env.current.tipChord)
                    },
                    set: {
                        self.env.current.tipChord = Double($0) ?? 0
                    }
                )
        let rootChord = Binding<String>(
                    get: {
                        String(self.env.current.rootChord)
                    },
                    set: {
                        self.env.current.rootChord = Double($0) ?? 0
                    }
                )
        let height = Binding<String>(
                    get: {
                        String(self.env.current.height)
                    },
                    set: {
                        self.env.current.height = Double($0) ?? 0
                    }
                )
        let thickness = Binding<String>(
                    get: {
                        String(self.env.current.thickness)
                    },
                    set: {
                        self.env.current.thickness = Double($0) ?? 0
                    }
                )
        let finsNumber = Binding<Int>(
                    get: {
                        self.env.current.finsNumber
                    },
                    set: {
                        self.env.current.finsNumber = $0
                    }
                )
        let proportional = Binding<String>(
                    get: {
                        String(self.env.current.kp)
                    },
                    set: {
                        self.env.current.kp = Double($0) ?? 0
                    }
                )
        let integral = Binding<String>(
                    get: {
                        String(self.env.current.ki)
                    },
                    set: {
                        self.env.current.ki = Double($0) ?? 0
                    }
                )
        let derivative = Binding<String>(
                    get: {
                        String(self.env.current.kd)
                    },
                    set: {
                        self.env.current.kd = Double($0) ?? 0
                    }
                )
        let gravityCentre = Binding<String>(
                    get: {
                        String(self.env.current.gravityCentre)
                    },
                    set: {
                        self.env.current.gravityCentre = Double($0) ?? 0
                    }
                )
        let pressureCentre = Binding<String>(
                    get: {
                        String(self.env.current.pressureCentre)
                    },
                    set: {
                        self.env.current.pressureCentre = Double($0) ?? 0
                    }
                )
        let mass = Binding<String>(
                    get: {
                        String(self.env.current.mass)
                    },
                    set: {
                        self.env.current.mass = Double($0) ?? 0
                    }
                )
        let booster = Binding<Motor>(
                    get: {
                        self.env.current.motor
                    },
                    set: {
                        self.env.current.motorType = $0.id
                    }
                )
        let boosterQuantity = Binding<Int>(
                    get: {
                        self.env.current.motorQuantity
                    },
                    set: {
                        self.env.current.motorQuantity = $0
                    }
                )
        
        return ScrollView(showsIndicators: false) {
            
            Image(env.current.id)
                .resizable()
                .scaledToFill()
                .frame(width: 800, height: 400)
            
            VStack {
                
                VStack(spacing: 50) {
                    
                    //Body Dimensions
                    
                    HStack {
                        Text("Dimensions")
                            .fontWeight(.medium)
                            .font(.system(size: 25))
                        Spacer()
                    }
                    
                    VStack {
                        HStack(spacing: 25) {
                            VStack {
                                HStack {
                                    Text("Length:")
                                        .font(.system(size: 15))
                                    TextField("Length", text: length)
                                        .font(.system(size: 15))
                                    Text("m")
                                        .font(.system(size: 15))
                                }
                                HStack {
                                    Text("Diameter:")
                                        .font(.system(size: 15))
                                    TextField("Diameter", text: diameter)
                                        .font(.system(size: 15))
                                    Text("m")
                                        .font(.system(size: 15))
                                }
                            }
                            .frame(width: 200)
                            Spacer()
                            Image("bodyDimensions")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.1)
                                .frame(height: 60)
                        }
                    }
                    
                    //Fin Dimensions
                    
                    VStack {
                        HStack {
                            Text("Number of fins:")
                                .font(.system(size: 15))
                            Stepper("\(env.current.finsNumber)", value: finsNumber, in: 0...8)
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack(spacing: 25) {
                            VStack {
                                HStack {
                                    Text("Tip chord:")
                                        .font(.system(size: 15))
                                    TextField("Tip chord", text: tipChord)
                                        .font(.system(size: 15))
                                    Text("m")
                                        .font(.system(size: 15))
                                }
                                HStack {
                                    Text("Root chord:")
                                        .font(.system(size: 15))
                                    TextField("Root chord", text: rootChord)
                                        .font(.system(size: 15))
                                    Text("m")
                                        .font(.system(size: 15))
                                }
                            }.frame(width: 200)
                            VStack {
                                HStack {
                                    Text("Height:")
                                        .font(.system(size: 15))
                                    TextField("Height", text: height)
                                        .font(.system(size: 15))
                                    Text("m")
                                        .font(.system(size: 15))
                                }
                                HStack {
                                    Text("Thickness:")
                                        .font(.system(size: 15))
                                    TextField("Thickness", text: thickness)
                                        .font(.system(size: 15))
                                    Text("m")
                                        .font(.system(size: 15))
                                }
                            }.frame(width: 200)
                            Spacer()
                            Image("finDimensions")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.1)
                                .frame(height: 60)
                        }
                        .opacity(env.current.finsNumber <= 0 ? 1/3 : 1)
                        .disabled(env.current.finsNumber <= 0)
                    }
                    
                    HStack {
                        Text("Properties")
                            .fontWeight(.medium)
                            .font(.system(size: 25))
                        Spacer()
                    }
                    
                    //Centers
                    VStack {
                        HStack {
                            VStack(spacing: 25) {
                                Image("weight")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.1)
                                    .frame(height: 150)
                                HStack {
                                    Text("Mass:")
                                        .font(.system(size: 15))
                                    TextField("Mass", text: mass)
                                        .font(.system(size: 15))
                                    Text("kg")
                                        .font(.system(size: 15))
                                }
                                .frame(width: 150)
                            }
                            Spacer()
                            VStack(spacing: 25) {
                                ZStack {
                                    Image("centers")
                                        .resizable()
                                        .scaledToFit()
                                        .opacity(0.1)
                                        .frame(height: 150)
                                    
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.blue)
                                        .frame(width: 15, height: 15)
                                        .offset(x: calculateCentre(for: env.current.gravityCentre, in: 325), y: 0)
                                    
                                    Image(systemName: "circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.red)
                                        .frame(width: 15, height: 15)
                                        .offset(x: calculateCentre(for: env.current.pressureCentre, in: 325), y: 0)
                                }
                                HStack(spacing: 25) {
                                    HStack {
                                        Text("CG:")
                                            .font(.system(size: 15))
                                        TextField("Gravity centre", text: gravityCentre)
                                            .font(.system(size: 15))
                                        Text("m")
                                            .font(.system(size: 15))
                                    }
                                    .frame(width: 150)
                                    HStack {
                                        Text("CP:")
                                            .font(.system(size: 15))
                                        TextField("Pressure centre", text: pressureCentre)
                                            .font(.system(size: 15))
                                        Text("m")
                                            .font(.system(size: 15))
                                    }
                                    .frame(width: 150)
                                }
                            }
                        }
                        .padding(.horizontal, 50)
                    }
                    
                    HStack {
                        Text("Propulsion")
                            .fontWeight(.medium)
                            .font(.system(size: 25))
                        Spacer()
                    }
                    
                    //Booster
                    
                    VStack {
                        HStack(spacing: 25) {
                            VStack {
                                HStack {
                                    Text("Number of boosters:")
                                        .font(.system(size: 15))
                                    Stepper("\(env.current.motorQuantity)", value: boosterQuantity, in: 1...5)
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                HStack {
                                    Text("Booster:")
                                        .font(.system(size: 15))
                                    Picker("", selection: booster) {
                                        ForEach(env.motors, id: \.self) { motor in
                                            Text(motor.name).tag(motor)
                                                .font(.system(size: 15))
                                        }
                                    }
                                }
                            }
                            .frame(width: 200)
                            Spacer()
                            Image("motor")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.1)
                                .frame(height: 30)
                        }
                    }
                    
                    //TVC
                    
                    HStack {
                        VStack {
                            HStack {
                                Text("Thrust Vector Control")
                                    .font(.system(size: 15))
                                Toggle(isOn: $env.current.tvc) { }
                                Spacer()
                            }
                            HStack(spacing: 25) {
                                HStack {
                                    Text("P:")
                                        .font(.system(size: 15))
                                    TextField("Proportional", text: proportional)
                                        .font(.system(size: 15))
                                }
                                .frame(width: 100)
                                HStack {
                                    Text("I:")
                                        .font(.system(size: 15))
                                    TextField("Integral", text: integral)
                                        .font(.system(size: 15))
                                }
                                .frame(width: 100)
                                HStack {
                                    Text("D:")
                                        .font(.system(size: 15))
                                    TextField("Derivative", text: derivative)
                                        .font(.system(size: 15))
                                }
                                .frame(width: 100)
                                Spacer()
                            }
                            .opacity(!env.current.tvc ? 1/3 : 1)
                            .disabled(!env.current.tvc)
                        }
                        Spacer()
                        Image(systemName: "move.3d")
                            .resizable()
                            .scaledToFit()
                            .opacity(!env.current.tvc ? 0.1 * 1/3 : 0.1)
                            .disabled(!env.current.tvc)
                            .frame(height: 50)
                    }
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 50)
            .frame(width: 800)
        }
    }
    
    func calculateCentre(for position: Double, in frame: Double) -> CGFloat {
        let start = frame / 2
        let percentage = position / env.current.length
        return CGFloat(start - frame * percentage)
    }
}

struct ConditionsEditor: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        let airDensity = Binding<String>(
                    get: {
                        String(self.env.conditions.airDensity)
                    },
                    set: {
                        self.env.conditions.airDensity = Double($0) ?? 0
                    }
                )
        let windSpeed = Binding<String>(
                    get: {
                        String(self.env.conditions.wind.magnitude)
                    },
                    set: {
                        self.env.conditions.wind.magnitude = Double($0) ?? 0
                    }
                )
        let windAngle = Binding<String>(
                    get: {
                        String(self.env.conditions.wind.angle)
                    },
                    set: {
                        let input = Double($0) ?? 0
                        var output = input - Double(input / 360).rounded(.down) * 360
                        if output < 0 {
                            output += 360
                        }
                        if output >= 360 {
                            output -= 360
                        }
                        self.env.conditions.wind.angle = output
                    }
                )
        
        return ZStack {
            Color.white
            
            HStack {
                Image(env.current.id)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .opacity(0.5)
                    .rotationEffect(.degrees(-67.5))
                
            }
            .offset(x: 200, y: 0)
            
            Spacer()
            HStack {
                Spacer()
                VStack {
                    HStack(spacing: 0) {
                        Text("Environment")
                            .bold()
                    }
                    
                    Spacer()
                        .frame(height: 25)
                    
                    HStack {
                        Text("Air Density (kg/m^):")
                        TextField("Air Density", text: airDensity)
                    }.aspectRatio(17, contentMode: .fit)
                    HStack {
                        Text("Wind  |")
                        Text("Speed (m/s):")
                        TextField("Wind Speed", text: windSpeed)
                        Text("Angle (º):")
                        TextField("Wind Angle", text: windAngle)
                            .aspectRatio(3 ,contentMode: .fit)
                    }.aspectRatio(17, contentMode: .fit)
                }
                Spacer()
            }
            .padding()
        }
        //.frame(width: 1000, height: 400, alignment: .center)
    }
}

struct ConditionsEditor_Previews: PreviewProvider {
    static var previews: some View {
        ConditionsEditor()
    }
}
