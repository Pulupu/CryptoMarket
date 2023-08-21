//
//  MarketScrollView.swift
//  CryptoMarket
//
//  Created by KimWu on 2023/8/20.
//

import SwiftUI

struct MarketScrollView: View {
    let marketDatas: [MarketData]
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(self.marketDatas, id: \.symbol) { marketData in
                    CoinItem(marketData: marketData)
                        .padding(.horizontal, 10)
                }
            }
        }
    }
}

