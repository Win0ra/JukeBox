//
//  ContentView.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var searchText = ""
    @EnvironmentObject var library: MusicLibrary
    @EnvironmentObject var user: User
    @State private var isPlaying = false
    @State private var currentMusic: Music?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var currentPlaylist: [Music] = []
    @State private var currentMusicIndex: Int = 0
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var errorMessage: String = ""
    @State private var joke: String = ""
    @State private var showJoke: Bool = false

    var filteredMusics: [Music] {
        if searchText.isEmpty {
            return library.musics
        } else {
            return library.musics.filter { $0.zone.contains(searchText) || $0.title.contains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("WoWBackgroundTop"), Color("WoWBackgroundBottom")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    if isLoggedIn {
                        List {
                            ForEach(filteredMusics) { music in
                                NavigationLink(destination: MusicDetailView(music: music)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(music.title)
                                                .font(.headline)
                                                .foregroundColor(Color("WoWGold"))
                                            Text(music.composer)
                                                .font(.subheadline)
                                                .foregroundColor(Color("WoWSecondary"))
                                        }
                                        Spacer()
                                        if user.playlists.values.flatMap({ $0 }).contains(music) {
                                            Button(action: {
                                                playMusic(music: music)
                                            }) {
                                                Image(systemName: "play.circle.fill")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(Color("WoWBlue"))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .navigationTitle("Jukebox WoW")
                        .searchable(text: $searchText)
                        .toolbar {
                            HStack {
                                Text("Hello, \(username)")
                                    .font(.headline)
                                    .foregroundColor(Color("WoWGold"))
                                NavigationLink(destination: PlaylistsView(isPlaying: $isPlaying, currentMusic: $currentMusic, audioPlayer: $audioPlayer, currentPlaylist: $currentPlaylist, currentMusicIndex: $currentMusicIndex)) {
                                    Text("Playlists")
                                        .foregroundColor(Color("WoWBlue"))
                                }
                                Button(action: {
                                    logout()
                                }) {
                                    Text("Logout")
                                        .font(.headline)
                                        .foregroundColor(Color("WoWRed"))
                                        .padding(.leading, 10)
                                }
                            }
                        }
                        Spacer()
                        if currentMusic != nil {
                            MusicPlayerView(isPlaying: $isPlaying, currentMusic: $currentMusic, audioPlayer: $audioPlayer, currentPlaylist: $currentPlaylist, currentMusicIndex: $currentMusicIndex)
                        }
                        if currentMusic == nil {
                            DisclosureGroup("Pssst, viens voir ici !", isExpanded: $showJoke) {
                                Button(action: {
                                    fetchJoke()
                                }) {
                                    Text("Clique ici !")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color("WoWGreen"))
                                        .cornerRadius(10)
                                }
                                .padding()

                                if !joke.isEmpty {
                                    Text(joke)
                                        .padding()
                                        .background(Color("WoWSecondary").opacity(0.2))
                                        .cornerRadius(10)
                                        .padding()
                                }
                            }
                            .padding()
                            .background(Color("WoWBackgroundTop").opacity(0.1))
                            .cornerRadius(10)
                            .padding()
                        }
                    } else {
                        VStack {
                            Image("jukebox")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .padding(.bottom, 20)
                                .cornerRadius(10.0)

                            TextField("x", text: $username, prompt: Text("Username")
                                .foregroundColor(.gray))
                            .padding(10)
                            .background(Color("WoWBackgroundTop").opacity(0.8))
                            .cornerRadius(10.0)
                            .padding(.bottom, 10)
                            .foregroundColor(Color("WoWGold"))
                            .font(.title3)

                            SecureField("x", text: $password, prompt: Text("Password")
                                .foregroundColor(.gray))
                            .padding(10)
                            .background(Color("WoWBackgroundTop").opacity(0.8))
                            .cornerRadius(10.0)
                            .padding(.bottom, 10)
                            .foregroundColor(Color("WoWGold"))
                            .font(.title3)

                            Button(action: {
                                login()
                            }) {
                                Text("Se connecter")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 220, height: 60)
                                    .background(Color("WoWBlue"))
                                    .cornerRadius(15.0)
                            }
                            .padding(.bottom, 10)

                            NavigationLink(destination: SignUpView()) {
                                Text("Créer un compte")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("WoWGold"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding()
                            }

                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .foregroundColor(Color("WoWRed"))
                                    .padding()
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }

    func playMusic(music: Music) {
        if let url = Bundle.main.url(forResource: music.filename, withExtension: nil) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
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

    func login() {
        let userDefaults = UserDefaults.standard
        if let storedPassword = userDefaults.string(forKey: username), storedPassword == password {
            isLoggedIn = true
            errorMessage = ""
            user.name = username
        } else {
            errorMessage = "Invalid username or password."
        }
    }

    func logout() {
        isLoggedIn = false
        username = ""
        password = ""
        user.name = ""
        currentMusic = nil
        currentPlaylist.removeAll()
        isPlaying = false
    }

    func fetchJoke() {
        let url = "https://official-joke-api.appspot.com/random_joke"
        let reqURL = URL(string: url)!
        let task = URLSession.shared.dataTask(with: reqURL) { data, response, error in
            if let data = data {
                do {
                    let jokeData = try JSONDecoder().decode(Joke.self, from: data)
                    DispatchQueue.main.async {
                        self.joke = "\(jokeData.setup) - \(jokeData.punchline)"
                    }
                } catch {
                    print("Error decoding joke: \(error)")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
}

struct Joke: Codable {
    let setup: String
    let punchline: String
}

