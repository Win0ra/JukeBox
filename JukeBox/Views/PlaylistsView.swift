//
//  PlaylistsView.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import SwiftUI
import AVFoundation

struct PlaylistsView: View {
    @EnvironmentObject var user: User
    @Binding var isPlaying: Bool
    @Binding var currentMusic: Music?
    @Binding var audioPlayer: AVAudioPlayer?
    @Binding var currentPlaylist: [Music]
    @Binding var currentMusicIndex: Int
    
    var body: some View {
        List {
            ForEach(user.playlists.keys.sorted(), id: \.self) { playlist in
                Section(header: Text(playlist)
                    .font(.headline)
                    .foregroundColor(Color("WoWGold"))
                    .padding(.vertical, 5)) {
                        ForEach(user.playlists[playlist] ?? [], id: \.id) { music in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(music.title)
                                        .font(.headline)
                                        .foregroundColor(Color("WoWBlue"))
                                    Text(music.zone)
                                        .font(.subheadline)
                                        .foregroundColor(Color("WoWSecondary"))
                                }
                                Spacer()
                                Button(action: {
                                    removeMusic(music, from: playlist)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        Button(action: {
                            withAnimation {
                                if isPlaying && currentPlaylist == (user.playlists[playlist] ?? []) {
                                    stopMusic()
                                } else {
                                    playPlaylist(user.playlists[playlist] ?? [])
                                }
                            }
                        }) {
                            Text(isPlaying && currentPlaylist == (user.playlists[playlist] ?? []) ? "Stop" : "Play Playlist")
                                .font(.headline)
                                .foregroundColor(isPlaying && currentPlaylist == (user.playlists[playlist] ?? []) ? Color("WoWRed") : Color("WoWGreen"))
                                .padding()
                                .background(Capsule().fill((isPlaying && currentPlaylist == (user.playlists[playlist] ?? []) ? Color("WoWRed") : Color("WoWGreen")).opacity(0.2)))
                        }
                        .padding(.vertical, 5)
                    }
                    .listRowBackground(Color("WoWBackground"))
            }
        }
        .navigationTitle("Playlists")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("WoWBackground").edgesIgnoringSafeArea(.all))
        .transition(.slide)
        .onAppear {
            loadSelectedPlaylist()
        }
    }
    
    func removeMusic(_ music: Music, from playlist: String) {
        if let index = user.playlists[playlist]?.firstIndex(of: music) {
            user.playlists[playlist]?.remove(at: index)
            savePlaylists()
        }
    }
    
    func savePlaylists() {
        // Logique pour enregistrer les playlists mises à jour (à implémenter)
    }
    
    func playPlaylist(_ playlist: [Music]) {
        guard !playlist.isEmpty else { return }
        currentPlaylist = playlist
        currentMusicIndex = 0
        playCurrentMusic()
        saveSelectedPlaylist()
    }
    
    func playCurrentMusic() {
        guard currentMusicIndex < currentPlaylist.count else {
            isPlaying = false
            return
        }
        let music = currentPlaylist[currentMusicIndex]
        if let url = Bundle.main.url(forResource: music.filename, withExtension: nil) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = AVDelegate(onFinish: {
                    if self.currentMusicIndex < self.currentPlaylist.count - 1 {
                        self.currentMusicIndex += 1
                        self.playCurrentMusic()
                    } else {
                        self.stopMusic()
                    }
                })
                audioPlayer?.play()
                currentMusic = music
                isPlaying = true
                saveSelectedPlaylist()
            } catch {
                print("Erreur de lecture du fichier audio : \(error)")
            }
        } else {
            print("Fichier audio non trouvé : \(music.filename)")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        isPlaying = false
        currentPlaylist.removeAll()
        saveSelectedPlaylist()
    }
    
    func saveSelectedPlaylist() {
        let musicFileName = currentMusic.map { $0.filename }
        UserDefaults.standard.set(musicFileName, forKey: "selectedPlaylist")
        UserDefaults.standard.set(currentMusicIndex, forKey: "currentMusicIndex")
    }
    
    func loadSelectedPlaylist() {
        let savedFilenames = UserDefaults.standard.array(forKey: "selectedPlaylist") as? [String] ?? []
        currentPlaylist = savedFilenames.compactMap { filename in
            user.playlists.values.flatMap { $0 }.first { $0.filename == filename }
        }
        currentMusicIndex = UserDefaults.standard.integer(forKey: "currentMusicIndex")
        if !currentPlaylist.isEmpty && currentMusicIndex < currentPlaylist.count {
            if let currentMusicFilename = UserDefaults.standard.string(forKey: "currentMusicFilename") {
                currentMusic = currentPlaylist.first { $0.filename == currentMusicFilename }
            }
            playCurrentMusic()
        }
    }
}
