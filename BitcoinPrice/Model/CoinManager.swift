//
//  CoinManager.swift
//  BitcoinPrice
//
//  Created by Aidyn Assan on 20.02.2022.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateCoinPrice(_ coinManager: CoinManager, price: String)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "23042B25-83FC-4A9C-BCFA-F21EFC62A731"

    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        performRequest(for: currency)
    }
    
    func performRequest(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{return}
                if let safeData = data{
                    let price = self.parseJSON(safeData)
                    self.delegate?.didUpdateCoinPrice(self, price: price)
                }
            }
            task.resume()
        }
        
    }
    
    private func parseJSON(_ currencyData: Data) -> String{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: currencyData)
            let price = String(format: "%.2f", decodedData.rate)
            return price
        }
        catch{
            return "JSONDecoder Error!"
        }
    }
    
    
}

