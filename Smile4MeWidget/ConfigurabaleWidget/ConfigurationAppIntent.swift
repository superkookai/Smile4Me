//
//  ConfigurationAppIntent.swift
//  Smile4Me
//
//  Created by Weerawut on 24/12/2568 BE.
//


import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Joke Options" }
    static var description: IntentDescription { "Choose language and category." }

    // Configurable parameters.
    @Parameter(title: "Language", default: nil)
    var language: LanguageEntity?
    
    @Parameter(title: "Category", default: nil)
    var category: CategoryEntity?
    
    @Parameter(title: "Mesh Background", default: false)
    var enabled: Bool
}

struct LanguageEntity: AppEntity {
    static var defaultQuery: LanguageQuery = LanguageQuery()
    
    var id: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "language")
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
}

struct LanguageQuery: EntityQuery {
    func suggestedEntities() async throws -> [LanguageEntity] {
        Language.allCases.map({ LanguageEntity(id: $0.name)})
    }
    
    func entities(for identifiers: [String]) async throws -> [LanguageEntity] {
        try await suggestedEntities().filter({identifiers.contains($0.id)})
    }
    
    func defaultResult() async -> LanguageEntity? {
        try? await suggestedEntities().first(where: {$0.id == "English"})
    }
}

struct CategoryEntity: AppEntity {
    static var defaultQuery: CategoryQuery = CategoryQuery()
    
    var id: Category.RawValue
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "category")
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
}

struct CategoryQuery: EntityQuery {
    func suggestedEntities() async throws -> [CategoryEntity] {
        Category.allCases.map({ CategoryEntity(id: $0.rawValue)})
    }
    
    func entities(for identifiers: [String]) async throws -> [CategoryEntity] {
        try await suggestedEntities().filter({identifiers.contains($0.id)})
    }
    
    func defaultResult() async -> CategoryEntity? {
        try? await suggestedEntities().first
    }
}
