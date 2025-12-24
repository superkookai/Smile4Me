//
//  JokeManager.swift
//  Smile4Me
//
//  Created by Weerawut on 22/12/2568 BE.
//

import Foundation
import OSLog

class JokeManager {
    let logger = Logger(subsystem: "Smile4Me.Service", category: "JokeManager")
    let issueUrl = "https://github.com/Sv443-Network/JokeAPI/issues/new?template=3_edit_a_joke.md&title="
    private let service = APIService()
    
    func getJoke(category: Category = .Any, language: Language = .en) async throws -> Joke {
        let urlString = "https://v2.jokeapi.dev/joke/\(category)?lang=\(language)&blacklistFlags=nsfw,religious,political,racist,sexist,explicit"
        logger.info("\(urlString)")
        
        return try await service.getJSON(from: urlString)
    }
    
    func getInfo() async throws -> Info {
        let urlString = "https://v2.jokeapi.dev/info"
        return try await service.getJSON(from: urlString)
    }
    
    func getLinkJoke(category: String, language: String, id: String) async throws -> Joke {
        let urlString = "https://v2.jokeapi.dev/joke/\(category)?lang=\(language)&idRange=\(id)"
        let service = APIService()
        return try await service.getJSON(from: urlString)
    }
}
