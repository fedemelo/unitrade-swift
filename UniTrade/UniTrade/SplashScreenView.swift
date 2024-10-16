//
//  SplashScreen.swift
//  UniTrade
//
//  Created by Mariana Ruiz Giraldo on 1/10/24.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSplash: Bool // Bind to app's state to control navigation

    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image("Logo Dark Mode")
                .resizable()
                .frame(width: 300, height: 300)

            Text("UniTrade")
                .font(Font.DesignSystem.headline800)
                .foregroundColor(Color.white)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.DesignSystem.primary900(for: colorScheme))
        .onAppear {
            // Delay for 3 seconds, then hide the splash screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview in both light and dark mode
        Group {
            SplashScreenView(showSplash: .constant(true))
                .preferredColorScheme(.light)
            SplashScreenView(showSplash: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}
