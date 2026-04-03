//
//  ContentView.swift
//  PrismExample
//
//  Created by Adi on 03/04/26.
//

import Prism
import SwiftUI

struct ContentView: View {
    @State private var selectedFamily: Int = 0
    @State private var selectedVariant: PrismVariant = .light
    @State private var liquidGlass: Bool = false

    var currentTheme: PrismThemeFamily {
        switch selectedFamily {
        case 1:  .neo(selectedVariant)
        case 2:  .neuromorphic(selectedVariant)
        default: .koreanAesthetic(selectedVariant)
        }
    }

    var body: some View {
        NavigationStack {
            TabView {
                Tab("Design Tokens", systemImage: "paintpalette") {
                    ThemeShowcaseView()
                }
                Tab("Components", systemImage: "square.grid.2x2") {
                    ComponentsShowcaseView(
                        selectedFamily: $selectedFamily,
                        selectedVariant: $selectedVariant,
                        liquidGlass: $liquidGlass
                    )
                }
                Tab("Overlays", systemImage: "rectangle.stack") {
                    OverlaysShowcaseView()
                }
                Tab("Sheets", systemImage: "arrow.up.square") {
                    SheetsShowcaseView()
                }
            }
            .navigationTitle("Prism Showcase")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Theme") {
                        Picker("Theme Family", selection: $selectedFamily) {
                            Text("Korean Aesthetic").tag(0)
                            Text("Neo").tag(1)
                            Text("Neuromorphic").tag(2)
                        }
                        Picker("Variant", selection: $selectedVariant) {
                            ForEach(PrismVariant.allCases, id: \.self) { variant in
                                Text(variant.rawValue.capitalized).tag(variant)
                            }
                        }
                        Toggle("Liquid Glass", isOn: $liquidGlass)
                    }
                }
            }
        }
        .prismTheme(currentTheme, liquidGlass: liquidGlass)
        .prismHUD()
    }
}

#Preview {
    ContentView()
}
