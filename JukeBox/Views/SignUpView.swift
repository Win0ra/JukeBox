//
//  SignUpView.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("WoWBackgroundTop"), Color("WoWBackgroundBottom")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
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
                
                SecureField("x", text: $confirmPassword, prompt: Text("Confirm Password")
                    .foregroundColor(.gray))
                    .padding(10)
                    .background(Color("WoWBackgroundTop").opacity(0.8))
                    .cornerRadius(10.0)
                    .padding(.bottom, 10)
                    .foregroundColor(Color("WoWGold"))
                    .font(.title3)
                
                Button(action: {
                    signUp()
                }) {
                    Text("Enregistrer")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color("WoWBlue"))
                        .cornerRadius(15.0)
                }
                .padding(.bottom, 20)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(Color("WoWRed"))
                        .padding()
                }
            }
            .padding()
        }
    }
    
    func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(password, forKey: username)
        errorMessage = "User signed up successfully."
    }
}
