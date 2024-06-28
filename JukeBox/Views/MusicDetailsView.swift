//
//  MusicDetailsView.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import SwiftUI
import AVFoundation

struct MusicDetailView: View {
    var music: Music
    @State private var audioPlayer: AVAudioPlayer?
    @EnvironmentObject var library: MusicLibrary
    @EnvironmentObject var user: User
    @State private var selectedPlaylist = "Combat"
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("WoWSecondary"), Color("WoWBackgroundBottom")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text(music.title)
                    .font(.largeTitle)
                    .foregroundColor(Color("WoWBackgroundBottom"))
                    .padding()
                Text("Zone: \(music.zone)")
                    .font(.headline)
                    .foregroundColor(Color("WoWGold"))
                    .padding()
                Text("Composer: \(music.composer)")
                    .font(.subheadline)
                    .foregroundColor(Color("WoWSecondary"))
                    .padding()
                Text(music.description)
                    .foregroundColor(Color("WoWSecondary"))
                    .padding()
                
                HStack {
                    Picker("Add to Playlist", selection: $selectedPlaylist) {
                        ForEach(user.playlists.keys.sorted(), id: \.self) { playlist in
                            Text(playlist)
                                .foregroundColor(.white)
                                .font(.headline)
                                .foregroundColor(Color("WoWGold"))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                HStack {
                    Spacer()
                    Button("Add to \(selectedPlaylist) Playlist") {
                        user.addToPlaylist(selectedPlaylist, music: music)
                    }
                    .padding()
                    .background(Color("WoWGold"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle(music.title)
        .transition(.slide)
        .animation(.default)
    }
    
    func togglePlay() {
        isPlaying.toggle()
        if isPlaying {
            playMusic(filename: music.filename)
        } else {
            audioPlayer?.pause()
        }
    }
    
    func playMusic(filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType: nil) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                if isPlaying {
                    audioPlayer?.play()
                }
            } catch {
                print("Erreur de lecture du fichier audio.")
                isPlaying = false
            }
        }
    }
}
