//
//  Extensions.swift
//  TicTacToe
//
//  Created by Luca Becker on 11.03.23.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func leftAlign() -> some View {
        HStack {
            self

            Spacer()
        }
    }
    
    func rightAlign() -> some View {
        HStack {
            Spacer()
            
            self
        }
    }

    func centerAlign() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

extension Color {
    static let backgroundColor = Color("backgroundColor")
    static let xColor = Color("XColor")
    static let oColor = Color("OColor")
    static let cardBackgroundColor = Color("cardBackgroundColor")
}


// MARK: App Icon
extension Bundle {
    var iconFileName: String? {
        guard let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last
        else { return nil }
        return iconFileName
    }
}

struct AppIcon: View {
    var body: some View {
        Bundle.main.iconFileName
            .flatMap { UIImage(named: $0) }
            .map { Image(uiImage: $0) }
    }
}
