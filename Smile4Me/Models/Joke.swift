//
//  Joke.swift
//  Smile4Me
//
//  Created by Weerawut on 22/12/2568 BE.
//

import Foundation

struct Joke: Decodable, Equatable {
    let id: Int
    let category: Category
    let type: JokeType
    let lang: Language
    let joke: String?
    let setup: String?
    let delivery: String?
    
    var fullJoke: String {
        switch type {
        case .single: return joke ?? ""
        case .twopart: return (setup ?? "") + "\n\n" + (delivery ?? "")
        }
    }
    
    static let single = Joke(
        id: 1,
        category: .Miscellaneous,
        type: .single,
        lang: .en,
        joke: "Never date a baker. They always have a surprise in store.",
        setup: nil,
        delivery: nil
    )
    
    static let twopart = Joke(
        id: 2,
        category: .Pun,
        type: .twopart,
        lang: .en,
        joke: nil,
        setup: "Which is faster, Hot or Cold?",
        delivery: "Hot because you can catch a cold!"
    )
    
}

enum Category: String, Decodable, CaseIterable, Identifiable {
    case `Any`,Programming,Miscellaneous,Dark,Pun,Spooky,Christmas
    var id: Self { self }
    
    var emoji: String {
        switch self {
        case .Any: return ""
        case .Programming: return "🤖"
        case .Miscellaneous: return "🎉"
        case .Dark: return "🌔"
        case .Pun: return "🥴"
        case .Spooky: return "👻"
        case .Christmas: return "🎅"
        }
    }
}

enum Language: String, Decodable, CaseIterable, Identifiable {
    case cs,de,en,es,fr,pt
    var id: Self { self }
    
    var name: String {
        switch self {
        case .cs: return "Czech"
        case .de: return "German"
        case .en: return "English"
        case .es: return "Spanish"
        case .fr: return "French"
        case .pt: return "Portuguese"
        }
    }
}

enum JokeType: String, Decodable {
    case twopart,single
}
