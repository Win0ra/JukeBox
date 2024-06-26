//
//  User.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import Foundation

class User: ObservableObject, Identifiable {
    @Published var name: String
    @Published var playlists: [String: [Music]] = [
        "Combat": [],
        "Exploration": [],
        "Relaxation": []
    ]
    
    init(name: String) {
        self.name = name
        loadPlaylistsFromUserDefaults()
    }
    
    func addToPlaylist(_ playlist: String, music: Music) {
        playlists[playlist, default: []].append(music)
        savePlaylistsToUserDefaults()
    }
    
    func removeFromPlaylist(_ playlist: String, music: Music) {
        playlists[playlist]?.removeAll { $0 == music }
        savePlaylistsToUserDefaults()
    }
    
    private func savePlaylistsToUserDefaults() {
        let encoder = JSONEncoder()
        if let encodedPlaylists = try? encoder.encode(playlists) {
            UserDefaults.standard.set(encodedPlaylists, forKey: "\(name)_playlistsData")
        }
    }
    
    private func loadPlaylistsFromUserDefaults() {
        if let savedPlaylistsData = UserDefaults.standard.data(forKey: "\(name)_playlistsData") {
            let decoder = JSONDecoder()
            if let loadedPlaylists = try? decoder.decode([String: [Music]].self, from: savedPlaylistsData) {
                playlists = loadedPlaylists
            }
        }
    }
}
