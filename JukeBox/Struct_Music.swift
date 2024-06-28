//
//  Struct_Music.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import SwiftUI
import Foundation

struct Music: Identifiable, Equatable, Codable {
    let id = UUID()
    let title: String
    let zone: String
    let composer: String
    let description: String
    let filename: String
}

