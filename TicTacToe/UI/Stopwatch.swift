//
//  Stopwatch.swift
//  TicTacToe
//
//  Created by Luca Becker on 13.03.23.
//

import SwiftUI

struct Stopwatch: View {
    
    /// Current progress time expresed in seconds
    @State private var progressTime = 0
    @State private var isRunning = false
    
    let numberFormatter: NumberFormatter =  {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumIntegerDigits = 2
        return numberFormatter
    }()
    
    /// Computed properties to get the progressTime in hh:mm:ss format
    var hours: Int {
        progressTime / 3600
    }
    
    var minutes: Int {
        (progressTime % 3600) / 60
    }
    
    var seconds: Int {
        progressTime % 60
    }
    
    /// Increase progressTime each second
    @State private var timer: Timer?
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "hourglass")
            if hours > 0 {
                Text(numberFormatter.string(from: NSNumber(value: hours)) ?? "")
                    .tracking(2)
                Text(":")
                    .offset(y: -1)
            }
            Text(numberFormatter.string(from: NSNumber(value: minutes)) ?? "")
                .tracking(2)
            Text(":")
                .offset(y: -1)
            Text(numberFormatter.string(from: NSNumber(value: seconds)) ?? "")
                .tracking(2)
        }
        .font(.title3)
        .fontWeight(.medium)
        .foregroundColor(.black)
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                progressTime += 1
            })
            isRunning.toggle()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

struct Stopwatch_Previews: PreviewProvider {
    static var previews: some View {
        Stopwatch()
            .previewLayout(.sizeThatFits)
    }
}
