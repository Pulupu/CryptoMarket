//
//  CoinItem.swift
//  CryptoMarket
//
//  Created by KimWu on 2023/8/20.
//

import SwiftUI

struct CoinItem: View {
    let marketData: MarketData
    var body: some View {
        HStack {
            Text(marketData.symbol)
            Spacer()
            if let price = marketData.price {
                Text("\(price)")
            } else {
                Image(systemName: "ellipsis")
            }
        }
        .padding(.all, 3)
        .border(.black, width: 1)
    }
}
