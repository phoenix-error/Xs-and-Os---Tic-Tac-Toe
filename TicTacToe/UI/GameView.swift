//
//  ContentView.swift
//  Xs & Os - Tic Tac Toe
//
//  Created by Luca Becker on 11.03.23.
//

import SwiftUI
import PopupView

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var gridLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    Spacer()
                    
                    PlayerView(for: proxy, player: .X)
                    
                    Image("lightningIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                        .padding()
                    PlayerView(for: proxy, player: .O)
                    Spacer()
                    
                    gameBoard()
                        .padding()
                        .frame(width: proxy.size.width * 0.9, height: proxy.size.width * 0.9 , alignment: .center)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: proxy.size.width / 12))
                        .centerAlign()
                        .shadow(color: Color.accentColor, radius: 5, x: 5, y: 5)
                    Spacer()
                }
                .background(Color.backgroundColor)
                .popup(item: $viewModel.popup) { popupItem in
                    VStack(spacing: 30) {
                        Text(popupItem.title)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(popupItem.message)
                            .font(.title3)
                    }
                    .padding(.vertical, 50)
                    .frame(width: proxy.size.width * 0.8)
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onDisappear {
                        viewModel.resetGame()
                    }
                } customize: {
                    $0
                        .animation(.spring())
                        .closeOnTapOutside(false)
                        .closeOnTap(true)
                }
                
                
            }
            .environmentObject(viewModel)
            .onChange(of: viewModel.difficulty) { _ in
                viewModel.resetGame()
            }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                        }
                    }
                }
        }
    }
    
    @ViewBuilder func gameBoard() -> some View {
        GeometryReader { proxy in
            LazyVGrid(columns: gridLayout, spacing: 0) {
                ForEach(0..<9, id: \.self) { ind in
                    RoundedRectangle(cornerRadius: proxy.size.width / 20)
                        .fill(viewModel.getCellState(for: ind) == nil ? Color.backgroundColor: Color.accentColor)
                        .padding(10)
                        .frame(width: proxy.size.width / 3, height: proxy.size.width / 3)
                        .if(viewModel.getCellState(for: ind) == nil) { view in
                            view.onTapGesture {
                                withAnimation {
                                    viewModel.makeMove(ind: ind)
                                }
                            }
                        }
                        .if(viewModel.getCellState(for: ind) != nil) { view in
                            view.overlay {
                                Text(viewModel.getCellState(for: ind)?.getName() ?? "")
                                    .frame(width: proxy.size.width / 5, height: proxy.size.width / 5)
                                    .font(.system(size: proxy.size.width / 6))
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.getCellState(for: ind) == .X ? .xColor : .oColor)
                            }
                        }
                        .disabled(viewModel.currentPlayer != .X)
                        .transition(.opacity)
                }
            }
        }.padding()
            
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct PlayerView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var proxy: GeometryProxy
    var player: Player
    
    var playerColor: Color {
        return player == .X ? .xColor: .oColor
    }
    
    init(for proxy: GeometryProxy, player: Player) {
        self.proxy = proxy
        self.player = player
    }
    
    var body: some View {
        HStack {
            Label {
                Text(player == .X ? "You": "Ai")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.leading)
            } icon: {
                Image(systemName: player == .X ? "person": "laptopcomputer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 30)
            }
            .foregroundColor(.black)
            Spacer()
            if viewModel.currentPlayer == player && !viewModel.gameState.isFinished {
                Stopwatch()
            } else if viewModel.gameState == .finished(winner: player){
                WinnerStarView(player: player)
            }
        }
        
        .frame(width: proxy.size.width * 0.7, alignment: .leading)
        .padding()
        .padding(.vertical, 10)
        .background(Color.cardBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: proxy.size.width / 24))
        .if (viewModel.currentPlayer == player) { view in
            view
                .overlay {
                    RoundedRectangle(cornerRadius: proxy.size.width / 24)
                        .stroke(playerColor, lineWidth: 3)
                        .shadow(color: playerColor, radius: 2, x: 2, y: 2)
                }
        }
    }
}


