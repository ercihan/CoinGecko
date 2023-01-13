//
//  ContentView.swift
//  iTunes
//
//  Created by Aaron Morf on 26.04.22.
//

import SwiftUI

struct ContentView: View {
    
    @State var data : CoinResults = CoinResults(coins: []);
    @State var search = "";
    
    var body: some View {
        NavigationView {
            VStack {
                List(data.coins) { item in
                    NavigationLink(item.name +
                                   " - " + item.symbol,
                                   destination:
                                    DetailView(viewModel: CoinViewModel(coinId: item.id)))
                }
                .onAppear(perform: {
                    Task {
                        data = try await searchCoins(search: search)
                    }
                })
                .refreshable(action: {
                    Task {
                        data = try await searchCoins(search: search)
                    }
                })
                .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Suchen") {
                }.onSubmit(of: .search)  {
                    Task {
                        data = try await searchCoins(search: search)
                    }
                }
            }
            .navigationTitle("Main")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
