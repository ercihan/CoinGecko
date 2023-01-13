//
//  FavoriteView.swift
//  CoinGecko
//
//  Created by Aaron Morf on 10.05.22.
//

import SwiftUI

struct FavoriteView: View {
    @State var data : [CoinDetail] = [];
    
    var body: some View {
        NavigationView {
            VStack {
                List(data) { item in
                    NavigationLink(item.name +
                                   " - " + item.symbol,
                                   destination: DetailView(viewModel: CoinViewModel(coin: item)))
                }
                .onAppear(perform: {
                    Task {
                        data = try await loadData()
                    }
                })
                .refreshable(action: {
                    Task {
                        data = try await loadData()
                    }
                })
            }
            .navigationTitle("Favorites")
        }
    }
    
    func loadData() async throws -> [CoinDetail] {
        do {
            let favs = UserDefaults.standard.stringArray(forKey: "FavoritCoins") ?? [];
            return try await favs.asyncMap { fav in
                try await loadCoin(id: fav)
            }
        }
        catch {
            fatalError("Couldn't load coins from server:\n\(error)")
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
