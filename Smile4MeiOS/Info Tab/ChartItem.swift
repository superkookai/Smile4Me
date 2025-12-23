//
//  ChartItem.swift
//  Smile4MeiOS
//
//  Created by Weerawut on 23/12/2568 BE.
//

import Foundation

struct ChartItem: Identifiable {
    var id = UUID()
    let lang: String
    let qty: Int
    let jokeType: JokeType
    
    enum JokeType: String {
        case safe,unsafe
    }
}
