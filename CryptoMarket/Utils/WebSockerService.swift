//
//  WebSockerService.swift
//  CryptoMarket
//
//  Created by KimWu on 2023/8/19.
//

import Foundation
import RxSwift
import RxCocoa

class WebSockerService: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private let baseURL = URL(string: "wss://ws.btse.com/ws/futures")
    
    var receivePriceData: Observable<[String: Any]>?
    
    func connect() async {
        self.cancel()
        self.webSocketTask = URLSession.shared.webSocketTask(with: self.baseURL!)
        self.webSocketTask?.resume()
        await self.seneMessage()
        self.initReceiveObservable()
    }
    
    func cancel() {
        self.webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func seneMessage() async {
        let string = "{\"op\":\"subscribe\",\"args\":[\"coinIndex\"]}"
        let message = URLSessionWebSocketTask.Message.string(string)
        do {
            try await self.webSocketTask?.send(message)
        } catch {
            print("WebSocket send message error: \(error)")
        }
    }
    
    func initReceiveObservable() {
        self.receivePriceData = Observable.create({ (observer) -> Disposable in
            self.webSocketTask?.receive { result in
                switch result {
                case .failure(let error):
                    print("WebSocket receive message error: \(error)")
                    break
                case .success(.string(let str)):
                    do {
                        if let info = (try JSONSerialization.jsonObject(with: Data(str.utf8)) as? [String: Any]),
                           let data = info["data"] as? [String: Any] {
                            observer.onNext(data)
                        } else {
                            observer.onNext([:])
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                    break
                default:
                    break
                }
            }
            return Disposables.create()
        })
    }
}
