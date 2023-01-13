//
//  Helpers.swift
//  CoinGecko
//
//  Created by Aaron Morf on 10.05.22.
//

import Foundation
import WebKit
import SwiftUI

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
}

extension Decimal {
    func currency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "de-CH")
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber)!
    }
}

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
        uiView.loadHTMLString(headerString + htmlContent, baseURL: nil)
    }
}
