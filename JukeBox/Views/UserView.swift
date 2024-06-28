//
//  UserView.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 28/06/2024.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var user: User

    var body: some View {
        NavigationView {
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
                                        user.removeFromPlaylist(playlist, music: music)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(Color("WoWRed"))
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color("WoWBackgroundTop").opacity(0.1))
                }
            }
            .navigationTitle("Playlists de \(user.name)")
            .navigationBarTitleDisplayMode(.inline)
            .background(LinearGradient(gradient: Gradient(colors: [Color("WoWBackgroundTop"), Color("WoWBackgroundBottom")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        }
    }
}
