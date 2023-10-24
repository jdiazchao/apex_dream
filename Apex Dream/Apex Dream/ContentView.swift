//
//  ContentView.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 23/3/21.
//

import SwiftUI

public class GlobalEnvironment: ObservableObject {
    @Published var memory: Rocket = Rocket()
    @Published var current: Rocket = Rocket()
    @Published var selected: Int = 0
    @Published var conditions: Conditions = Conditions()
    
    @Published var page: Page = Page.editor
    
    @Published var data: FlightData? = nil
    @Published var test: TestData? = nil
    
    @Published var motors: [Motor] = Bundle.main.decode(Array<Motor>.self, from: "motors.json")
    @Published var rockets: [Rocket] = Bundle.main.decode(Array<Rocket>.self, from: "rockets.json")
}

enum Page {
    case editor, flight, visual, test
}

struct ContentView: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    @State var show: Bool = false
    @State var play: Bool = false
    @State var settings: Bool = false
    
    var body: some View {
        Group {
            if env.page == .flight && env.data != nil {
                if play {
                    Visual(data: env.data!)
                } else {
                    FlightResults(data: env.data!)
                }
            } else if env.page == .test && env.test != nil {
                TestResults(data: env.test!)
            } else {
                if settings {
                    ConditionsEditor()
                } else {
                    RocketPicker()
                }
            }
        }
        .toolbar {
            if env.page == .flight || env.page == .visual {
                Button(action: {
                    play.toggle()
                }) {
                    if play {
                        Label("Stop", systemImage: "eye.slash")
                    } else {
                        Label("Play", systemImage: "eye")
                    }
                }
                .animation(nil)
            } else {
                Button(action: {
                    settings.toggle()
                }) {
                    if settings {
                        Label("Back", systemImage: "gearshape")
                    } else {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                }
                .animation(nil)
            }
            Button(action: {
                switch env.page {
                case .editor:
                    DispatchQueue.global(qos: .userInteractive).async {
                            let data = testSim(rocket: env.current, environment: env.conditions)
                            DispatchQueue.main.async {
                                env.test = data
                            }
                        }
                    env.page = .test
                default:
                    env.page = .editor
                }
            }) {
                if show {
                    Label("Test", systemImage: "triangle.fill")
                } else {
                    Label("Test", systemImage: "triangle.fill")
                }
            }
            .keyboardShortcut("t", modifiers: [.command])
            .animation(nil)
            Button(action: {
                switch env.page {
                case .editor:
                    DispatchQueue.global(qos: .userInteractive).async {
                            let data = flightSimOld(rocket: env.current, environment: env.conditions)
                            DispatchQueue.main.async {
                                env.data = data
                            }
                        }
                    env.page = .flight
                default:
                    env.page = .editor
                    env.data = nil
                }
            }) {
                if env.page != .editor {
                    Label("Run", systemImage: "stop.fill")
                } else {
                    Label("Run", systemImage: "play.fill")
                }
            }
            .keyboardShortcut("r", modifiers: [.command])
            .animation(nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
