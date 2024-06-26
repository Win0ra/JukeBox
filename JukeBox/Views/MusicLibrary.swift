//
//  MusicLibrary.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import Foundation
//import Combine

class MusicLibrary: ObservableObject {
    @Published var musics: [Music] = [
        Music(title: "Elwynn Forest", zone: "Elwynn Forest", composer: "Jason Hayes", description: "A peaceful melody from the human starting zone.", filename: "Elwynn_Forest.mp3"),
        Music(title: "Durotar", zone: "Durotar", composer: "Tracy W. Bush", description: "The harsh, rugged theme of the orc starting zone.", filename: "Durotar.mp3"),
        Music(title: "Stormwind", zone: "Stormwind City", composer: "Jason Hayes", description: "The majestic and heroic theme of Stormwind City.", filename: "Stormwind.mp3"),
        Music(title: "Orgrimmar", zone: "Orgrimmar", composer: "Tracy W. Bush", description: "The powerful and tribal theme of the orc capital.", filename: "Orgrimmar.mp3"),
        Music(title: "Teldrassil", zone: "Teldrassil", composer: "Jason Hayes", description: "The mystical and serene theme of the night elf starting zone.", filename: "Teldrassil.mp3"),
        Music(title: "Grizzly Hills", zone: "Grizzly Hills", composer: "Russell Brower", description: "The rustic and evocative theme from the Grizzly Hills in Northrend.", filename: "Grizzly_Hills.mp3"),
        Music(title: "Zuldazar", zone: "Zuldazar", composer: "Neal Acree", description: "The vibrant and exotic theme of Zuldazar.", filename: "Zuldazar.mp3"),
        Music(title: "Nazjatar", zone: "Nazjatar", composer: "Glenn Stafford", description: "The eerie and mysterious theme of the underwater zone Nazjatar.", filename: "Nazjatar.mp3"),
        Music(title: "Ardenweald", zone: "Ardenweald", composer: "Glenn Stafford", description: "The ethereal and enchanting theme of Ardenweald.", filename: "Ardenweald.mp3")
        // Add more music here
    ]
}
