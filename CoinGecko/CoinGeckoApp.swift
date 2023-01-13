//
//  CoinGeckoApp.swift
//  CoinGecko
//
//  Created by Aaron Morf on 03.05.22.
//

import SwiftUI

@main
struct CoinGeckoApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Menu", systemImage: "list.dash")
                    }

                FavoriteView()
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
            }
        }
    }
}
