//
//  WinnerStarView.swift
//  TicTacToe
//
//  Created by Luca Becker on 15.03.23.
//

import SwiftUI

struct WinnerStarView: View {
    var player: Player
    var body: some View {
        ZStack {
            Image(systemName: "star.fill")
                .offset(x: -20, y: 5)
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
                .imageScale(.medium)
            Image(systemName: "star.fill")
                .offset(x: 20, y: 5)
        }.offset(x: -30).foregroundColor(player == .X ? .xColor: .oColor)
    }
}
