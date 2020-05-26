//
//  NetworkManager.swift
//  ex26
//
//  Created by Gor on 5/26/20.
//  Copyright © 2020 user1. All rights reserved.
//

import UIKit

var BASE_URL = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=Linkin")

class Result: Codable {
    let results: [Track]
}

class NetworkManager {

static let instance = NetworkManager()

    func getTracks (from url: URL = BASE_URL!, completion: @escaping ([Track]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let decoder = JSONDecoder()
            if let data = data, let result = try? decoder.decode(Result.self, from: data) {
                completion(result.results)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
