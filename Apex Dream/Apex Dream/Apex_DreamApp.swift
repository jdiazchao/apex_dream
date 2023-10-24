//
//  Apex_DreamApp.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 6/3/21.
//

import SwiftUI

@main
struct Apex_DreamApp: App {
    let persistenceController = PersistenceController.shared
    
    var env = GlobalEnvironment()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(env)
            
            /*Main()
                .environmentObject(env)*/
            
            /*CoreDataView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)*/
        }
    }
}
