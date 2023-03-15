//
//  SettingsView.swift
//  TicTacToe
//
//  Created by Luca Becker on 15.03.23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(StorageKeys.wins.key) var wins = 0
    @AppStorage(StorageKeys.losses.key) var losses = 0
    @AppStorage(StorageKeys.draws.key) var draws = 0
    @AppStorage(StorageKeys.streak.key) var streak = 0
    @AppStorage(StorageKeys.highestStreak.key) var maxStreak = 0
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 50)
            VStack(alignment: .leading) {
                Text("Statistics")
                    .font(.title3)
                    .fontWeight(.medium)
                
                VStack(spacing: 0) {
                    HStack {
                        ForEach(["W", "L", "D", "Streak", "max Streak"], id: \.self) { key in
                            Text(key)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    Divider()
                        .frame(height: 2)
                        .overlay(Color.accentColor)
                        .padding(5)
                    
                    HStack {
                        Text("\(wins)")
                            .frame(maxWidth: .infinity)
                        Text("\(losses)")
                            .frame(maxWidth: .infinity)
                        Text("\(draws)")
                            .frame(maxWidth: .infinity)
                        Text("\(streak)")
                            .frame(maxWidth: .infinity)
                        Text("\(maxStreak)")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 16.0)
                        .stroke(Color.accentColor, lineWidth: 2)
                }
            }
            .padding()
            .background(Color.cardBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
            .padding()
            
            
            DifficultyView()
            
            Spacer()
            SettingsFooter()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}

struct DifficultyView: View {
    @AppStorage(StorageKeys.difficulty.key) var difficulty: ComputerDifficulty = .smart
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Difficulty")
                .font(.title3)
                .fontWeight(.medium)
            
            Picker("", selection: $difficulty) {
                ForEach(ComputerDifficulty.allCases) { difficulty in
                    Text(difficulty.rawValue).tag(difficulty)
                }
            }.pickerStyle(.segmented)
        }
        .padding()
        .background(Color.cardBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16.0))
        .padding()
    }
    
}


struct SettingsFooter: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    struct FooterSpacer: View {
        var body: some View {
            Circle()
                .foregroundColor(.secondary)
                .frame(width: 5)
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Version \(appVersion ?? "") ")
                
                FooterSpacer()
                
                Link("Privacy", destination: URL(string: "https://google.de")!)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                FooterSpacer()
                
                Link("Terms", destination: URL(string: "https://google.de")!)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Text("Made with ❤️ by @Luca")
        }
        .centerAlign()
        .padding(.top)
        .foregroundColor(.secondary)
    }
}
