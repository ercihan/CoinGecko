//
//  DetailView.swift
//  CoinGecko
//
//  Created by Aaron Morf on 10.05.22.
//

import SwiftUI
//import SwiftUICharts

struct DetailView : View {
    @ObservedObject var viewModel: CoinViewModel
    @State var isFavorit = false;
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Color.clear.onAppear(perform: {
                Task {
                    await viewModel.load()
                }
            })
        case .loading:
            ProgressView()
        case .failed(let error):
            fatalError("Couldn't load coin from server:\n\(error)")
        case .loaded(let coin):
            VStack() {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(coin.symbol).italic().font(.caption)
                        Text(coin.market_data.current_price.chf.currency())
                    }
                    Spacer()
                    AsyncImage(url: URL(string: coin.image.large)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 100, maxHeight: 100)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                }.padding()
                HTMLStringView(htmlContent: coin.description.en).padding()
                //LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen").padding()
            }
                .navigationTitle(coin.name)
                .toolbar {
                    ToolbarItem {
                        Button {
                            var fav = UserDefaults.standard.stringArray(forKey: "FavoritCoins") ?? [];
                            if (self.isFavorit) {
                                fav.remove(at: fav.firstIndex(of: coin.id)!)
                                self.isFavorit = false;
                            } else {
                                fav.append(coin.id)
                                self.isFavorit = true;
                            }
                            UserDefaults.standard.set(fav, forKey: "FavoritCoins");
                            UserDefaults.standard.synchronize();
                        } label: {
                            Label("Edit", systemImage: self.isFavorit ? "star.fill" : "star")
                        }
                    }
                }
                .refreshable(action: {
                    Task {
                        await viewModel.load()
                    }
                })
                .onAppear {
                    let favs = UserDefaults.standard.stringArray(forKey: "FavoritCoins")
                    self.isFavorit = favs?.contains(coin.id) ?? false
                }
        }
    }
}

class CoinViewModel: ObservableObject {
    enum ViewState {
        case idle
        case loading
        case failed(Error)
        case loaded(CoinDetail)
    }
    
    @Published private(set) var state = ViewState.idle
    
    private let coinId: String
    
    init(coinId: String) {
        self.coinId = coinId
    }
    
    init(coin: CoinDetail) {
        self.coinId = coin.id
        self.state = .loaded(coin)
    }
    
    func load() async {
        state = .loading
        
        do {
            let coin = try await loadCoin(id: coinId)
            self.state = .loaded(coin)
        }
        catch {
            self.state = .failed(error)
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
