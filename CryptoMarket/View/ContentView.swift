//
//  ContentView.swift
//  CryptoMarket
//
//  Created by KimWu on 2023/8/19.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    let tabs: [MarketDataType] = [MarketDataType.spot,
                                  MarketDataType.future]
    
    
    @StateObject private var viewModel = MarketViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                MarketSlidingTabView(tabs: self.tabs, selectedTab: self.$selectedTab, viewModel: self.viewModel) {
                    TabView(selection: self.$selectedTab) {
                        if self.viewModel.dataReady {
                            ForEach(self.tabs.indices, id: \.self) { index in
                                if let marketDatas = self.viewModel.marketDatas[self.tabs[index]] {
                                    MarketScrollView(marketDatas: marketDatas)
                                }
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                .frame(height: UIScreen.main.bounds.height * 0.7)
            }
            .onAppear {
                self.viewModel.fetchMarketData()
            }
        }
       
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
