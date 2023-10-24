//
//  Line Graph.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 29/3/21.
//

import Foundation
import SwiftUI

struct Graph: View {
    @State var xSpotlight: Double = 0
    @State var ySpotlight: Double = 0
    
    var xData: [Double]
    var xMax: Double {
        return xData.max() ?? 0
    }
    var xMin: Double {
        return xData.min() ?? 0
    }
    
    var yData: [Double]
    var yMax: Double {
        return yData.max() ?? 0
    }
    var yMin: Double {
        return yData.min() ?? 0
    }
    
    var width: Double
    var height: Double
    
    var spacing: Double = 50
    
    var xInstances: Double {
        return width / spacing
    }
    
    var xInterval: Double {
        return xMax / xInstances
    }
    
    var yInstances: Double {
        return height / spacing
    }
    
    var yInterval: Double {
        return yMax / yInstances
    }
    
    var body: some View {
        let spotlight = Binding<String>(
                    get: {
                        String(self.xSpotlight)
                    },
                    set: {
                        let input = Double($0) ?? 0
                        let idx = xData.firstIndex(where: { $0 >= input }) ?? -1
                        if idx <= 0 {
                            ySpotlight = 0
                            self.xSpotlight = 0
                        } else {
                            ySpotlight = yData[idx]
                            self.xSpotlight = input
                        }
                    }
                )
        
        return VStack {
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    ForEach(0...Int(yInstances), id: \.self) { idx in
                        VStack(spacing: 0) {
                            Text("\(String(format: "%.1f", yMax - (Double(idx) * yInterval)))")
                            Spacer()
                        }
                        .frame(height: 50)
                    }
                }
                VStack(alignment: .leading) {
                    ZStack {
                        GraphGrid(xData: xData, xMax: xMax, xMin: xMin, yData: yData, yMax: yMax, yMin: yMin, width: width, height: height, spacing: spacing, xInstances: xInstances, yInstances: yInstances)
                            .stroke(Color(.lightGray), lineWidth: 1)
                            .opacity(0.2)
                            .border(Color.black, width: 1)
                            .background(Color.white)
                            .clipped()
                            .frame(width: 1000, height: 500)
                        LineGraph(xData: xData, xMax: xMax, xMin: xMin, yData: yData, yMax: yMax, yMin: yMin)
                            .stroke(Color.blue, lineWidth: 4)
                            .border(Color.black, width: 1)
                            .clipped()
                            .frame(width: 1000, height: 500)
                        GraphSpotlight(spotlight: $xSpotlight, xData: xData, xMax: xMax, xMin: xMin, yData: yData, yMax: yMax, yMin: yMin, width: width, height: height, spacing: spacing, xInstances: xInstances, yInstances: yInstances)
                            .stroke(Color(.lightGray), lineWidth: 1)
                            .border(Color.black, width: 1)
                            .clipped()
                            .frame(width: 1000, height: 500)
                        VStack() {
                            HStack() {
                                Spacer()
                                HStack(spacing: 0) {
                                    Text("x: ")
                                        .font(.system(size: 15))
                                    TextField("x", text: spotlight)
                                        .font(.system(size: 15))
                                        .frame(width: 50)
                                    Text(", y: \(String(format: "%.1f", ySpotlight))")
                                        .font(.system(size: 15))
                                }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .frame(width: 1000, height: 500)
                    .offset(x: 10, y: -5)
                    HStack(spacing: 0) {
                        ForEach(0...Int(xInstances), id: \.self) { idx in
                            HStack(spacing: 0) {
                                Text("\(String(format: "%.1f", Double(idx) * xInterval))")
                                Spacer()
                            }
                            .frame(width: 50)
                        }
                    }
                }
                Spacer()
            }
            Text("Time (s)")
        }
    }
    
    struct LineGraph: Shape {
        var xData: [Double]
        var xMax: Double
        var xMin: Double
        
        var yData: [Double]
        var yMax: Double
        var yMin: Double

        func path(in rect: CGRect) -> Path {
            func point(at ix: Int) -> CGPoint {
                let point = yData[ix]
                let x = rect.width / CGFloat(xData.count - 1) * CGFloat(ix)
                let y = rect.height - ((rect.height / CGFloat(yMax - yMin) * CGFloat(point /*- yMin*/)))
                
                
                return CGPoint(x: x, y: y)
            }

            return Path { p in
                guard yData.count > 1 else { return }
                let start = yData[0]
                p.move(to: CGPoint(x: 0, y: rect.height - (rect.height / CGFloat(yMax) * CGFloat(start))))
                for idx in yData.indices {
                    p.addLine(to: point(at: idx))
                }
            }
        }
    }

    struct GraphGrid: Shape {
        var xData: [Double]
        var xMax: Double
        var xMin: Double
        
        var yData: [Double]
        var yMax: Double
        var yMin: Double
        
        var width: Double
        var height: Double
        
        var spacing: Double
        var xInstances: Double
        var yInstances: Double

        func path(in rect: CGRect) -> Path {
            return Path { p in
                guard yData.count > 1 else { return }
                for idx in 0...Int(xInstances) {
                    p.move(to: CGPoint(x: idx * 50, y: 0))
                    p.addLine(to: CGPoint(x: idx * 50, y: Int(height)))
                }
                for idx in 0...Int(yInstances) {
                    p.move(to: CGPoint(x: 0, y: Int(height) - idx * 50))
                    p.addLine(to: CGPoint(x: Int(width), y: Int(height) - idx * 50))
                }
            }
        }
    }
    
    struct GraphSpotlight: Shape {
        @Binding var spotlight: Double
        
        var xData: [Double]
        var xMax: Double
        var xMin: Double
        
        var yData: [Double]
        var yMax: Double
        var yMin: Double
        
        var width: Double
        var height: Double
        
        var spacing: Double
        var xInstances: Double
        var yInstances: Double

        func path(in rect: CGRect) -> Path {
            return Path { p in
                guard yData.count > 1 else { return }
                p.move(to: CGPoint(x: rect.width * (CGFloat(spotlight) / CGFloat(xMax)), y: rect.height))
                p.addLine(to: CGPoint(x: rect.width * (CGFloat(spotlight) / CGFloat(xMax)), y: 0))
            }
        }
    }
}
