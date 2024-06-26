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
        VStack {
            Image("jukebox")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.bottom, 20)
            
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            .padding(.bottom, 20)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color("WoWBackgroundTop"), Color("WoWBackgroundBottom")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
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
