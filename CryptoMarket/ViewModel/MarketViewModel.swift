//
//  MarketViewModel.swift
//  CryptoMarket
//
//  Created by KimWu on 2023/8/19.
//
import SwiftUI
import RxSwift
import RxCocoa

enum MarketDataType: CaseIterable {
    case spot
    case future
    
    func tabString() -> String{
        switch self {
        case .spot:
            return "Spot"
        case .future:
            return "Futures"
        }
    }
}

class MarketViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    
    private var service = WebSockerService()
    
    @Published var marketDatas: [MarketDataType: [MarketData]] = [:]
    @Published var marketSpotDatas: [MarketData] = []
    @Published var marketFuturesDatas: [MarketData] = []
    @Published var dataReady: Bool = false
    
    func sortData(sortType: SortType, direction: Bool) {
        for type in MarketDataType.allCases {
            switch sortType {
            case .name:
                self.marketDatas[type]?.sort(by: { data1, data2 in
                    (data1.symbol > data2.symbol) == direction
                })
            case .price:
                self.marketDatas[type]?.sort(by: { data1, data2 in
                    (data1.price ?? -1 > data2.price ?? -1) == direction
                })
            }
        }
    }
    
    func fetchMarketData() {
        let url = URL(string: "https://api.btse.com/futures/api/inquire/initial/market")!
        let requset = URLRequest(url: url)
        URLSession.shared.rx.response(request: requset)
            .map { response, data in
                try JSONDecoder().decode(MarketResponse.self, from: data)
            }
            .observe(on: MainScheduler.instance)
            .subscribe { data in
                if let marketDatas = data.element?.data {
                    self.marketDatas[MarketDataType.spot] = marketDatas.filter({ data in
                        data.future == false
                    })
                    self.marketDatas[MarketDataType.spot]?.sort(by: { data1, data2 in
                        data1.symbol < data2.symbol
                    })
                    self.marketDatas[MarketDataType.future] = marketDatas.filter({ data in
                        data.future == true
                    })
                    self.marketDatas[MarketDataType.future]?.sort(by: { data1, data2 in
                        data1.symbol < data2.symbol
                    })
                    self.dataReady = true
                    self.startWebSocketService()
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func startWebSocketService() {
        Task {
            await self.service.connect()
            self.receivePriceData()
        }
    }
    
    private func receivePriceData() {
        self.service.receivePriceData?.subscribe(onNext: { [weak self] priceData in
            for type in MarketDataType.allCases {
                if let datas = self?.marketDatas[type] {
                    for (index, data) in datas.enumerated() {
                        if let price = (priceData["\(data.symbol)_1"] as? [String: Any])?["price"] as? CGFloat {
                            DispatchQueue.main.async {
                                self?.marketDatas[type]?[index].price = price
                            }                            
                        }
                    }
                }
            }
            self?.receivePriceData()
        })
        .disposed(by: self.disposeBag)
    }
}
