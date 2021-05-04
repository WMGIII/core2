//
//  core2App.swift
//  core2
//
//  Created by WMIII on 2021/4/5.
//

import SwiftUI

@main
struct core2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
