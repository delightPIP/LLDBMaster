//
//  LLDBMasterApp.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI
import SwiftData

@main
struct LLDBMasterApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: TodoTask.self, User.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
