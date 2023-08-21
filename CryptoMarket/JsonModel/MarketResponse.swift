//
//  MarketResponse.swift
//  CryptoMarket
//
//  Created by KimWu on 2023/8/19.
//

import Foundation

struct MarketResponse: Decodable {
    let time: Int?
    let message: String?
    let code: Int?
    let data: [MarketData]?
}

struct MarketData: Decodable {
    let future: Bool
    let symbol: String
    var price: CGFloat?
}
