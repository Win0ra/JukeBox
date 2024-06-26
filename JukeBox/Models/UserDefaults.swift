//
//  UserDefaults.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let selectedPlaylist = "selectedPlaylist"
        static let currentMusicIndex = "currentMusicIndex"
        static let currentMusicFilename = "currentMusicFilename"
    }
    
    var selectedPlaylist: [String] {
        get {
            return array(forKey: Keys.selectedPlaylist) as? [String] ?? []
        }
        set {
            set(newValue, forKey: Keys.selectedPlaylist)
        }
    }
    
    var currentMusicIndex: Int {
        get {
            return integer(forKey: Keys.currentMusicIndex)
        }
        set {
            set(newValue, forKey: Keys.currentMusicIndex)
        }
    }
    
    var currentMusicFilename: String? {
        get {
            return string(forKey: Keys.currentMusicFilename)
        }
        set {
            set(newValue, forKey: Keys.currentMusicFilename)
        }
    }
}

