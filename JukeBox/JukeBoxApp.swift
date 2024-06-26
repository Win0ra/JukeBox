//
//  JukeBox_V2App.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import SwiftUI

@main
struct JukeBoxApp: App {
    @StateObject private var user = User(name: "")
    @StateObject private var library = MusicLibrary()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(library)
        }
    }
}

