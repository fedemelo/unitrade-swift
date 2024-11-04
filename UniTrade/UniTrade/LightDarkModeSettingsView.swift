//
//  LightDarkModeSettingsView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 19/10/24.
//

import SwiftUI

struct LightDarkModeSettingsView: View {
    @EnvironmentObject var modeSettings: ModeSettings
    @Environment(\.colorScheme) var colorScheme
    
    enum Mode {
        case light, dark, automatic
    }
    
    var body: some View {
        List {
            Section(header: Text("Appearance")) {
                HStack {
                    ModeRadioButton(
                        image: "sun.max.fill",
                        label: "Light",
                        mode: .light,
                        selectedMode: $modeSettings.selectedMode,
                        colorScheme: colorScheme
                    )
                    
                    Spacer()
                    
                    ModeRadioButton(
                        image: "moon.fill",
                        label: "Dark",
                        mode: .dark,
                        selectedMode: $modeSettings.selectedMode,
                        colorScheme: colorScheme
                    )
                }
                .padding(.vertical)
                .padding(.horizontal, 50)
            }
            
            // Automatic Time-Aware Toggle
            Section(header: Text("Automatic Settings")) {
                HStack {
                    Toggle(isOn: Binding(
                        get: { modeSettings.selectedMode == .automatic },
                        set: { newValue in
                            if newValue {
                                modeSettings.selectedMode = .automatic
                            } else {
                                modeSettings.selectedMode = modeSettings.selectedMode == .automatic ? .light : modeSettings.selectedMode
                            }
                        }
                    )) {
                        Text("Automatic time-aware")
                    }
                    .tint(Color.DesignSystem.primary900())
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Light/Dark Mode")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ModeRadioButton: View {
    var image: String
    var label: String
    var mode: LightDarkModeSettingsView.Mode
    @Binding var selectedMode: LightDarkModeSettingsView.Mode
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 110)
                .foregroundColor(Color.DesignSystem.dark900(for: colorScheme))
            
            RadioButton(isSelected: selectedMode == mode) {
                selectedMode = mode
            }
            .contentShape(Rectangle())
            
            Text(label).padding(.vertical, 10)
        }
        .onTapGesture {
            selectedMode = mode
        }
    }
}

struct RadioButton: View {
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .foregroundColor(isSelected ? Color.DesignSystem.primary900() : .gray)
        }
        .contentShape(Rectangle())
    }
}
