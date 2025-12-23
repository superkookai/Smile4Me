//
//  TranslationService.swift
//  Smile4MeiOS
//
//  Created by Weerawut on 23/12/2568 BE.
//

import Foundation
import Translation

@Observable
class TranslationService {
    var translatedText = ""
    var avialbleLanguages: [AvailableLanguage] = []
    
    init() {
        getSupportedLanguages()
    }
    
    func getSupportedLanguages() {
        Task { @MainActor in
            let supportedLanguages = await LanguageAvailability().supportedLanguages
            avialbleLanguages = supportedLanguages.map({ local in
                AvailableLanguage(locale: local)
            }).sorted()
        }
    }
    
    func translate(text: String, session: TranslationSession) async throws {
        let response = try await session.translate(text)
        translatedText = response.targetText
    }
}
