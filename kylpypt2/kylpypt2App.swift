//
//  kylpypt2App.swift
//  kylpypt2
//
//  Created by Leo Wilson on 11/22/23.
//

import SwiftUI

@main
struct kylpypt2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(webVM: jsonWebVM())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
