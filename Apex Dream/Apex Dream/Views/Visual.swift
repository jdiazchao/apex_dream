//
//  Visual.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 4/4/21.
//

import SwiftUI

struct YVisual: View {
    var data: FlightData
    
    @State var time = 0.0
    @State var instance = 0
    @State var isEditing = false
    @State var play = false

    var body: some View {
        let timer = Timer.publish(every: data.interval, on: .main, in: .common).autoconnect()
        var time = Binding<Double>(
                    get: {
                        self.time
                    },
                    set: {
                        let input = $0
                        var output = input / data.interval
                        output.round()
                        self.instance = Int(output)
                        self.time = input
                    }
                )
        
        return ZStack {
            Color.white
            VStack {
                HStack {
                    ZStack {
                        Color(.lightGray)
                            .opacity(0.1)
                        Image(data.rocket.id)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(-data.rotation[instance]))
                            .offset(x: 275 * CGFloat(data.UXdisplacement[instance] / data.UXaltitude.max()!),
                                    y: 260 - (510 * CGFloat(data.UXaltitude[instance] / data.UXaltitude.max()!)))
                        VStack {
                            HStack {
                                Text("(\(String(format: "%.0f", data.UXdisplacement[instance])) m, \(String(format: "%.0f", data.UXaltitude[instance])) m)")
                                    .font(.system(size: 20))
                                Spacer()
                            }
                            /*HStack {
                                Text("(\(String(format: "%.0f", data.UXliftMagnitude[instance])) N, \(String(format: "%.0f", data.UXliftAngle[instance]))º)")
                                    .font(.system(size: 20))
                                Spacer()
                            }*/
                            Spacer()
                        }
                        .padding()
                    }
                    .frame(width: 550, height: 550)
                    .border(Color.black, width: 0.5)
                    ZStack {
                        Image(data.rocket.id)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 550, height: 550)
                            .rotationEffect(.degrees(-data.rotation[instance]))
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color.yellow)
                            .frame(width: arrowMagnitude(from: data.UXthrustMagnitude), height: arrowMagnitude(from: data.UXthrustMagnitude))
                            .offset(x: arrowMagnitude(from: data.UXthrustMagnitude) / 2, y: 0)
                            .rotationEffect(.degrees(-data.UXthrustAngle[instance]))
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color.red)
                            .frame(width: arrowMagnitude(from: data.UXweightMagnitude), height: arrowMagnitude(from: data.UXweightMagnitude))
                            .offset(x: arrowMagnitude(from: data.UXweightMagnitude) / 2, y: 0)
                            .rotationEffect(.degrees(-data.UXweightAngle[instance]))
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color.blue)
                            .frame(width: arrowMagnitude(from: data.UXdragMagnitude), height: arrowMagnitude(from: data.UXdragMagnitude))
                            .offset(x: arrowMagnitude(from: data.UXdragMagnitude) / 2, y: 0)
                            .rotationEffect(.degrees(-data.UXdragAngle[instance]))
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color(.cyan))
                            .frame(width: arrowMagnitude(from: data.UXliftMagnitude), height: arrowMagnitude(from: data.UXliftMagnitude))
                            .offset(x: arrowMagnitude(from: data.UXliftMagnitude) / 2, y: 0)
                            .rotationEffect(.degrees(-data.UXliftAngle[instance]))
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("v = \(String(format: "%.0f", data.UXvelocity[instance])) m/s")
                                        .font(.system(size: 20))
                                }
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    if data.rocket.tvc {
                                        Text("e = \(String(format: "%.1f", data.error[instance]))º")
                                            .font(.system(size: 20))
                                    }
                                    Text("α = \(String(format: "%.1f", data.attackAngle[instance]))º")
                                        .font(.system(size: 20))
                                }
                            }
                        }
                    }
                    .frame(width: 550, height: 550)
                    HStack {
                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .opacity(0.1)
                                .frame(width: 10, height: 550)
                            Rectangle()
                                .opacity(0.5)
                                .frame(width: 10, height: 550 * CGFloat(data.UXaltitude[instance] / data.UXaltitude.max()!))
                        }
                        VStack {
                            Text("\(String(format: "%.0f", data.UXaltitude.max() ?? 0)) m")
                                .font(.system(size: 20))
                            Spacer()
                        }
                    }
                    .frame(height: 550)
                }
                .scaleEffect(isEditing ? 0.95 : 1)
                .padding()
                HStack {
                    Button(action: {
                        self.time = 0
                        self.instance = Int(self.time / data.interval)
                    }) {
                        Image(systemName: "backward.end")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                    }
                    Button(action: {
                        if self.time > 5 {
                            self.time -= 5
                        } else {
                            self.time = 0
                        }
                        self.instance = Int(self.time / data.interval)
                    }) {
                        Image(systemName: "gobackward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                    }
                    Button(action: {
                        play.toggle()
                    }) {
                        if play {
                            Image(systemName: "pause")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                        } else {
                            Image(systemName: "play")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                        }
                    }
                    Slider(
                        value: time,
                        in: 0...data.maxTime,
                        onEditingChanged: { editing in
                            withAnimation(.spring()) {
                                isEditing = editing
                            }
                        }
                    )
                    Text("T-\(String(format: "%.0f", self.time))s")
                        .opacity(isEditing ? 0.5 : 1)
                }
                .aspectRatio(16, contentMode: .fit)
                .padding()
            }
            .padding()
            .onReceive(timer) { _ in
                if play && !isEditing {
                    if self.time <= (data.maxTime - data.interval) {
                        self.time += data.interval
                        self.instance = Int(self.time / data.interval)
                    } else {
                        self.time = data.maxTime
                        self.instance = Int(self.time / data.interval)
                        play.toggle()
                    }
                }
            }
        }
    }
    
    func arrowMagnitude(from array: [Double]) -> CGFloat {
        let percentage = CGFloat(array[instance] / array.max()!)
        //return 30 * percentage
        if array[instance] <= 0 {
            return 0
        } else {
            return 60
        }
    }
    
    func extremeValue(from array: [Double]) -> Double {
        let max = array.max()!
        let min = array.min()!
        
        if abs(max) > abs(min) {
            return abs(max)
        } else {
            return abs(min)
        }
    }
}

struct Visual: View {
    var data: FlightData
    
    @State var time = 0.0
    @State var instance = 0
    @State var isEditing = false
    @State var play = false

    var body: some View {
        let timer = Timer.publish(every: data.interval, on: .main, in: .common).autoconnect()
        var time = Binding<Double>(
                    get: {
                        self.time
                    },
                    set: {
                        let input = $0
                        var output = input / data.interval
                        output.round()
                        self.instance = Int(output)
                        self.time = input
                    }
                )
        
        return VStack(alignment: .center, spacing: 0) {
            ScrollView() {
                VStack() {
                    HStack {
                        VStack {
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("\(String(format: "%.1f", data.position.map{$0.y}[instance])) m")
                                        .offset(x: 0, y: -485 * CGFloat(data.position.map{$0.y}[instance] / extremeValue(from: data.position.map{$0.y})))
                                }
                                .frame(height: 500)
                                ZStack(alignment: .bottom) {
                                    Rectangle()
                                        .opacity(0.1)
                                        .frame(width: 10, height: 500)
                                    VStack {
                                        Rectangle()
                                            .opacity(0.5)
                                            .frame(width: 10, height: 500 * CGFloat(data.position.map{$0.y}[instance] / data.position.map{$0.y}.max()!))
                                    }
                                }.frame(height: 500)
                            }
                            Spacer()
                        }
                        .frame(width: 100)
                        VStack {
                            ZStack {
                                Color.white
                                Image(data.rocket.id)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .rotationEffect(.degrees(-data.rotation[instance]))
                                    .offset(x: CGFloat(data.position.map{$0.x}[instance] * proportionality(width: 1000, height: 500)),
                                            y: 250 - CGFloat(data.position.map{$0.y}[instance] * proportionality(width: 1000, height: 500)))
                                VStack {
                                    HStack {
                                        Spacer()
                                        ZStack {
                                            Image("velocityLayout")
                                                .resizable()
                                                .scaledToFit()
                                                .opacity(0.1)
                                                .frame(height: 100)
                                            Image("velocityIndicator")
                                                .resizable()
                                                .scaledToFit()
                                                .rotationEffect(.degrees(-120 + 240 * (data.velocity.map{$0.magnitude}[instance] / data.velocity.map{$0.magnitude}.max()!)))
                                                .frame(height: 100)
                                            VStack {
                                                Spacer()
                                                Text("\(String(format: "%.1f", data.velocity.map{$0.magnitude}[instance])) m/s")
                                            }
                                        }
                                        .frame(width: 100, height: 100)
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                            .frame(width: 1000, height: 500)
                            .clipped()
                            .border(Color.black, width: 1)
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .opacity(0.1)
                                        .frame(width: 1000, height: 10)
                                    HStack {
                                        Spacer()
                                            .frame(width: displacementSpacerWidth(for: false), height: 10)
                                        Rectangle()
                                            .opacity(0.5)
                                            .frame(width: 500 * CGFloat(abs(data.position.map{$0.x}[instance] / extremeValue(from: data.position.map{$0.x}))), height: 10)
                                        Spacer()
                                            .frame(width: displacementSpacerWidth(for: true), height: 10)
                                    }
                                }
                                Text("\(String(format: "%.1f", data.position.map{$0.x}[instance])) m")
                                    .offset(x: 475 * CGFloat(data.position.map{$0.x}[instance] / extremeValue(from: data.position.map{$0.x})), y: 0)
                            }
                        }
                        Spacer()
                            .frame(width: 25)
                        VStack {
                            VStack {
                                ZStack {
                                    Image(data.rocket.id)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .rotationEffect(.degrees(-data.rotation[instance]))
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(Color.yellow)
                                        .frame(width: arrowMagnitude(from: data.UXthrustMagnitude), height: arrowMagnitude(from: data.UXthrustMagnitude))
                                        .offset(x: arrowMagnitude(from: data.UXthrustMagnitude) / 2, y: 0)
                                        .rotationEffect(.degrees(-data.UXthrustAngle[instance]))
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(Color.red)
                                        .frame(width: arrowMagnitude(from: data.UXweightMagnitude), height: arrowMagnitude(from: data.UXweightMagnitude))
                                        .offset(x: arrowMagnitude(from: data.UXweightMagnitude) / 2, y: 0)
                                        .rotationEffect(.degrees(-data.UXweightAngle[instance]))
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(Color.blue)
                                        .frame(width: arrowMagnitude(from: data.UXdragMagnitude), height: arrowMagnitude(from: data.UXdragMagnitude))
                                        .offset(x: arrowMagnitude(from: data.UXdragMagnitude) / 2, y: 0)
                                        .rotationEffect(.degrees(-data.UXdragAngle[instance]))
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(Color(.cyan))
                                        .frame(width: arrowMagnitude(from: data.UXliftMagnitude), height: arrowMagnitude(from: data.UXliftMagnitude))
                                        .offset(x: arrowMagnitude(from: data.UXliftMagnitude) / 2, y: 0)
                                        .rotationEffect(.degrees(-data.UXliftAngle[instance]))
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Pitch")
                                            }
                                            Spacer()
                                        }
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                ZStack {
                                                    Image("velocityLayout")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .opacity(0.1)
                                                        .frame(height: 50)
                                                    Image("velocityIndicator")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .rotationEffect(.degrees(-120 + 240 * abs(data.angularVelocity[instance] / extremeValue(from: data.angularVelocity))))
                                                        .frame(height: 50)
                                                }
                                                .frame(width: 50, height: 50)
                                                .offset(x: 0, y: 10)
                                            }
                                        }
                                    }
                                }
                                .frame(width: 150, height: 150)
                                HStack {
                                    Spacer()
                                    Text("\(String(format: "%.1f", data.angularVelocity[instance])) m/s")
                                }
                                .frame(width: 150)
                            }
                            Spacer()
                            VStack {
                                ZStack {
                                    Image(data.rocket.id)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .rotationEffect(.degrees(-90))
                                        .opacity(0.5)
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Yaw")
                                            }
                                            Spacer()
                                        }
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                ZStack {
                                                    Image("velocityLayout")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .opacity(0.1)
                                                        .frame(height: 50)
                                                    Image("velocityIndicator")
                                                        .resizable()
                                                        .scaledToFit()
                                                        //.rotationEffect(.degrees(-120 + 240 * abs(data.angularVelocity[instance] / extremeValue(from: data.angularVelocity))))
                                                        .frame(height: 50)
                                                }
                                                .frame(width: 50, height: 50)
                                                .offset(x: 0, y: 10)
                                            }
                                        }
                                        .opacity(0.5)
                                    }
                                }
                                .frame(width: 150, height: 150)
                                HStack {
                                    Spacer()
                                    Text("\(0) m/s")
                                        .opacity(0.5)
                                }
                                .frame(width: 150)
                            }
                            Spacer()
                            VStack {
                                ZStack {
                                    Image(data.rocket.id)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .rotationEffect(.degrees(-90))
                                        .opacity(0.5)
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Roll")
                                            }
                                            Spacer()
                                        }
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                ZStack {
                                                    Image("velocityLayout")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .opacity(0.1)
                                                        .frame(height: 50)
                                                    Image("velocityIndicator")
                                                        .resizable()
                                                        .scaledToFit()
                                                        //.rotationEffect(.degrees(-120 + 240 * abs(data.angularVelocity[instance] / extremeValue(from: data.angularVelocity))))
                                                        .frame(height: 50)
                                                }
                                                .frame(width: 50, height: 50)
                                                .offset(x: 0, y: 10)
                                            }
                                        }.opacity(0.5)
                                    }
                                }
                                .frame(width: 150, height: 150)
                                HStack {
                                    Spacer()
                                    Text("\(0) m/s")
                                        .opacity(0.5)
                                }
                                .frame(width: 150)
                            }
                        }
                        .frame(height: 500)
                        Spacer()
                            .frame(width: 100)
                    }
                }
                .padding()
                .onReceive(timer) { _ in
                    if play && !isEditing {
                        if self.time <= (data.maxTime - data.interval) {
                            self.time += data.interval
                            self.instance = Int(self.time / data.interval)
                        } else {
                            self.time = data.maxTime
                            self.instance = Int(self.time / data.interval)
                            play.toggle()
                        }
                    }
                }
            }
            Divider()
            HStack(spacing: 20) {
                HStack {
                    Group {
                        Image(systemName: "backward.end.fill")
                            .resizable()
                            .scaledToFit()
                            .font(Font.title.weight(.ultraLight))
                            .opacity(0.9)
                            .frame(width: 15, height: 15)
                    }
                    .onTapGesture {
                        self.time = 0
                        self.instance = Int(self.time / data.interval)
                    }
                    Group {
                        Image(systemName: "gobackward")
                            .resizable()
                            .scaledToFit()
                            .font(Font.title.weight(.heavy))
                            .opacity(0.9)
                            .frame(width: 15, height: 15)
                    }
                    .onTapGesture {
                        if self.time > 5 {
                            self.time -= 5
                        } else {
                            self.time = 0
                        }
                        self.instance = Int(self.time / data.interval)
                    }
                    Group {
                        if play {
                            Image(systemName: "pause.fill")
                                .resizable()
                                .scaledToFit()
                                .font(Font.title.weight(.ultraLight))
                                .opacity(0.9)
                                .frame(width: 15, height: 15)
                        } else {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .font(Font.title.weight(.ultraLight))
                                .opacity(0.9)
                                .frame(width: 15, height: 15)
                        }
                    }
                    .onTapGesture {
                        play.toggle()
                    }
                }
                Slider(
                    value: time,
                    in: 0...data.maxTime,
                    onEditingChanged: { editing in
                        withAnimation(.spring()) {
                            isEditing = editing
                        }
                    }
                )
                Text("T-\(String(format: "%.0f", self.time))s")
                    .opacity(isEditing ? 0.5 : 1)
            }
            .padding(.horizontal, 50)
            .padding(.vertical)
        }
    }
    
    func displacementSpacerWidth(for spacer: Bool) -> CGFloat {
        switch spacer {
        case false:
            if data.position.map{$0.x}[instance] >= 0 {
                return 500
            } else {
                return 500 - 500 * CGFloat(abs(data.position.map{$0.x}[instance] / extremeValue(from: data.position.map{$0.x})))
            }
        case true:
            if data.position.map{$0.x}[instance] >= 0 {
                return 500 - 500 * CGFloat(abs(data.position.map{$0.x}[instance] / extremeValue(from: data.position.map{$0.x})))
            } else {
                return 500
            }
        }
    }
    
    func arrowMagnitude(from array: [Double]) -> CGFloat {
        let percentage = CGFloat(array[instance] / array.max()!)
        //return 30 * percentage
        if array[instance] <= 0 {
            return 0
        } else {
            return 30
        }
    }
    
    func proportionality(width: Double, height: Double) -> Double {
        let horizontalMax = extremeValue(from: data.position.map { $0.x })
        let verticalMax = extremeValue(from: data.position.map { $0.y })
        
        if verticalMax >= verticalMax {
            return height / verticalMax
        } else {
            return width / 2 / horizontalMax
        }
    }
    
    func extremeValue(from array: [Double]) -> Double {
        let max = array.max()!
        let min = array.min()!
        
        if abs(max) > abs(min) {
            return abs(max)
        } else {
            return abs(min)
        }
    }
}

/*struct Visual_Previews: PreviewProvider {
    static var previews: some View {
        Visual()
    }
}*/
