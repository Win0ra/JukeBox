//
//  MusicPlayerView.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import SwiftUI
import AVFoundation

enum RepeatMode {
    case none, one, all
}

struct MusicPlayerView: View {
    @Binding var isPlaying: Bool
    @Binding var currentMusic: Music?
    @Binding var audioPlayer: AVAudioPlayer?
    @Binding var currentPlaylist: [Music]
    @Binding var currentMusicIndex: Int
    @State private var currentTime: TimeInterval = 0
    @State private var repeatMode: RepeatMode = .none
    @State private var isShuffle: Bool = false
    @State private var isExpanded: Bool = true
    
    private var duration: TimeInterval {
        audioPlayer?.duration ?? 0
    }
    
    // Timer pour la mise à jour du temps
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if let music = currentMusic {
                VStack {
                    HStack {
                        Text(music.title)
                            .font(isExpanded ? .largeTitle : .headline)
                            .foregroundColor(Color("WoWGold"))
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }) {
                            Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                                .foregroundColor(Color("WoWGold"))
                        }
                    }
                    .padding(.bottom, isExpanded ? 2 : 0)
                    
                    if isExpanded {
                        Text(music.zone)
                            .font(.title3)
                            .foregroundColor(Color("WoWSecondary"))
                            .padding(.bottom, 20)
                        
                        MusicControlsView(isPlaying: $isPlaying, previousTrack: previousTrack, togglePlayPause: togglePlayPause, nextTrack: nextTrack)
                        ProgressView(currentTime: $currentTime, duration: duration)
                        ShuffleRepeatView(isShuffle: $isShuffle, repeatMode: $repeatMode)
                    } else {
                        MusicControlsView(isPlaying: $isPlaying, previousTrack: previousTrack, togglePlayPause: togglePlayPause, nextTrack: nextTrack)
                    }
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color("WoWBackgroundTop"), Color("WoWBackgroundBottom")]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
            }
        }
        .onReceive(timer) { _ in
            updateCurrentTime()
        }
    }
    
    func updateCurrentTime() {
        if let player = audioPlayer, player.isPlaying {
            currentTime = player.currentTime
        }
    }
    
    func togglePlayPause() {
        isPlaying.toggle()
        if isPlaying {
            audioPlayer?.play()
        } else {
            audioPlayer?.pause()
        }
    }
    
    func nextTrack() {
        if isShuffle {
            currentMusicIndex = Int.random(in: 0..<currentPlaylist.count)
        } else {
            if currentMusicIndex < currentPlaylist.count - 1 {
                currentMusicIndex += 1
            } else if repeatMode == .all {
                currentMusicIndex = 0
            } else {
                return
            }
        }
        playCurrentTrack()
    }
    
    func previousTrack() {
        if currentMusicIndex > 0 {
            currentMusicIndex -= 1
            playCurrentTrack()
        } else if repeatMode == .all {
            currentMusicIndex = currentPlaylist.count - 1
            playCurrentTrack()
        }
    }
    
    func playCurrentTrack() {
        let music = currentPlaylist[currentMusicIndex]
        
        // Stop current playing audio if any
        audioPlayer?.stop()
        audioPlayer = nil
        
        if let url = Bundle.main.url(forResource: music.filename, withExtension: nil) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = AVDelegate(onFinish: {
                    if self.repeatMode == .one {
                        self.playCurrentTrack()
                    } else {
                        self.nextTrack()
                    }
                })
                audioPlayer?.play()
                currentMusic = music
                isPlaying = true
            } catch {
                print("Erreur de lecture du fichier audio : \(error)")
            }
        } else {
            print("Fichier audio non trouvé : \(music.filename)")
        }
    }
}

struct MusicControlsView: View {
    @Binding var isPlaying: Bool
    var previousTrack: () -> Void
    var togglePlayPause: () -> Void
    var nextTrack: () -> Void
    
    var body: some View {
        HStack {
            Button(action: previousTrack) {
                Image(systemName: "backward.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("WoWBlue"))
                    .padding(10)
            }
            Button(action: togglePlayPause) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color("WoWBlue"))
                    .padding(10)
            }
            Button(action: nextTrack) {
                Image(systemName: "forward.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("WoWBlue"))
                    .padding(10)
            }
        }
        .padding(.bottom, 20)
    }
}

struct ProgressView: View {
    @Binding var currentTime: TimeInterval
    var duration: TimeInterval
    
    var body: some View {
        VStack {
            Slider(value: $currentTime, in: 0...duration, onEditingChanged: { _ in })
                .accentColor(Color("WoWGold"))
            HStack {
                Text(formatTime(currentTime))
                    .font(.caption)
                    .foregroundColor(Color("WoWGold"))
                Spacer()
                Text(formatTime(duration))
                    .font(.caption)
                    .foregroundColor(Color("WoWGold"))
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ShuffleRepeatView: View {
    @Binding var isShuffle: Bool
    @Binding var repeatMode: RepeatMode
    
    var body: some View {
        HStack {
            Button(action: {
                isShuffle.toggle()
            }) {
                Image(systemName: "shuffle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isShuffle ? Color("WoWSecondary") : Color("WoWGold"))
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.2)))
            }
            Spacer()
            Button(action: {
                switch repeatMode {
                case .none:
                    repeatMode = .one
                case .one:
                    repeatMode = .all
                case .all:
                    repeatMode = .none
                }
            }) {
                Image(systemName: repeatMode == .one ? "repeat.1" : "repeat")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(repeatMode != .none ? Color("WoWSecondary") : Color("WoWGold"))
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.2)))
            }
        }
        .padding(.top, 5)
    }
}

// Extension to define the color scheme for World of Warcraft
extension Color {
    static let WoWBlue = Color(red: 0.0, green: 0.25, blue: 0.5)
    static let WoWGold = Color(red: 0.85, green: 0.65, blue: 0.13)
    static let WoWSecondary = Color(red: 0.75, green: 0.75, blue: 0.75)
    static let WoWBackgroundTop = Color(red: 0.1, green: 0.1, blue: 2.0)
    static let WoWBackgroundBottom = Color(red: 0.0, green: 0.0, blue: 0.1)
}
