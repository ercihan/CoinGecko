//
//  Models.swift
//  CoinGecko
//
//  Created by Aaron Morf on 10.05.22.
//

import Foundation

struct CoinResults : Decodable {
    var coins : [CoinResult]
}

struct CoinResult : CoinBase {
    var id: String
    var name: String
    var symbol: String
    var large : String
}

struct CoinDetail : CoinBase {
    var id: String
    var name: String
    var symbol: String
    var image : CoinImage
    var market_data : CoinMarketData
    var description : CoinText
}

protocol CoinBase : Identifiable, Decodable {
    var id: String { get set }
    var name: String { get set }
    var symbol: String { get set }
}

struct CoinText : Decodable {
    var en: String
}

struct CoinMarketData : Decodable {
    var current_price: CoinPrice
}

struct CoinImage : Decodable {
    var thumb: String
    var small: String
    var large: String
}

struct CoinPrice : Decodable {
    var chf: Decimal
    var usd: Decimal
}
