//
//  Info.swift
//  Smile4Me
//
//  Created by Weerawut on 23/12/2568 BE.
//

import Foundation

struct Info: Decodable {
    let jokes: Jokes
}

struct Jokes: Decodable {
    let totalCount: Int
    let idRange: [String: [Int]]
    let safeJokes: [SafeJoke]
    
    var langCount: [String: Int] {
        idRange.mapValues { range in
            guard !range.isEmpty else { return 0 }
            return range.last ?? 0
        }
    }
}

struct SafeJoke: Decodable {
    let lang: String
    let count: Int
}
