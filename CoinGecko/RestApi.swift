//
//  RestApi.swift
//  CoinGecko
//
//  Created by Aaron Morf on 10.05.22.
//

import Foundation

func loadCoin(id: String) async throws -> CoinDetail {
    do {
        let url = URLComponents(string: "https://api.coingecko.com/api/v3/coins/" + id)!
        let urlRequest = URLRequest(url: url.url!)
        let (data, _) =
        try await URLSession.shared.data(for: urlRequest)
        print(url)
        let result = try JSONDecoder().decode(CoinDetail.self, from: data)
        print(result)
        return result
    }
    catch {
        fatalError("Couldn't load coin from server:\n\(error)")
    }
}

func searchCoins(search: String) async throws -> CoinResults {
    var url = URLComponents(string: "https://api.coingecko.com/api/v3/search")!
    url.queryItems = [URLQueryItem(name: "query", value: search)]
    let urlRequest = URLRequest(url: url.url!)
    let (data, _) =
    try await URLSession.shared.data(for: urlRequest)
    let result = try JSONDecoder().decode(CoinResults.self, from: data)
    return result
}
