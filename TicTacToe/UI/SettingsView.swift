//
//  SettingsView.swift
//  TicTacToe
//
//  Created by Luca Becker on 15.03.23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(StorageKeys.difficulty.rawValue) var difficulty: ComputerDifficulty = .smart
    var body: some View {
        ScrollView {
            Spacer(minLength: 30)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AppIcon()
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
