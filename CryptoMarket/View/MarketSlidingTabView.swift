//
//  SlidingTabView.swift
//  CryptoMarket
//
//  Created by KimWu on 2023/8/20.
//

import SwiftUI

enum SortType {
    case name
    case price
}

struct MarketSlidingTabView<Content: View>: View {
    let tabs: [MarketDataType]
    @Binding var selectedTab: Int
    var viewModel: MarketViewModel
    @State private var sortType: SortType = .name
    @State private var sortDirection: [SortType: Bool] = [SortType.name: false, SortType.price: false]
    let content: Content
    
    init(tabs: [MarketDataType], selectedTab: Binding<Int>, viewModel: MarketViewModel, @ViewBuilder content: () -> Content) {
        self.tabs = tabs
        self._selectedTab = selectedTab
        self.viewModel = viewModel
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack() {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selectedTab = index
                            }
                        }) {
                            Text(tabs[index].tabString())
                                .font(.headline)
                                .padding(10)
                                .foregroundColor(selectedTab == index ? .blue : .gray)
                        }
                    }
                    Spacer()
                    Button(action: {
                        if self.sortType == .name {
                            self.sortDirection[SortType.name]?.toggle()
                        }
                        self.viewModel.sortData(sortType: .name, direction: self.sortDirection[SortType.name]!)
                        self.sortType = .name
                    }) {
                        HStack(spacing: 3) {
                            Text("name")
                                .font(.headline)
                                .padding(.vertical, 10)
                                .foregroundColor(self.sortType == .name ? .blue : .gray)
                            Image(systemName: self.sortDirection[SortType.name] == false ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 8)
                                .foregroundColor(.gray)
                                
                        }
                    }
                    Button(action: {
                        if self.sortType == .price {
                            self.sortDirection[SortType.price]?.toggle()
                        }
                        self.viewModel.sortData(sortType: .price, direction: self.sortDirection[SortType.price]!)
                        self.sortType = .price
                    }) {
                        HStack(spacing: 3) {
                            Text("price")
                                .font(.headline)
                                .padding(.vertical, 10)
                                .foregroundColor(self.sortType == .price ? .blue : .gray)
                            Image(systemName: self.sortDirection[SortType.price] == false ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 8)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .background(Color.white)
            
            Divider()
                .padding(.bottom, 3)
            
            self.content
        }
    }
}
