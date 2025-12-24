//
//  ConfigurableWidgetProvider.swift
//  Smile4Me
//
//  Created by Weerawut on 24/12/2568 BE.
//


import WidgetKit
import SwiftUI

struct ConfigurableWidgetProvider: AppIntentTimelineProvider {
    let jokeManager = JokeManager()
    
    func placeholder(in context: Context) -> ConfigurableEntry {
        ConfigurableEntry(date: Date(), configuration: ConfigurationAppIntent(), joke: Joke.single)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> ConfigurableEntry {
        let joke = try? await jokeManager.getJoke()
        return ConfigurableEntry(date: Date(), configuration: configuration, joke: joke)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<ConfigurableEntry> {
        var entries: [ConfigurableEntry] = []
        let category = Category.allCases.first(where: {$0.rawValue == configuration.category?.id}) ?? .Any
        let language = Language.allCases.first(where: {$0.name == configuration.language?.id}) ?? .en
        

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let joke = try? await jokeManager.getJoke(category: category, language: language)
            let entry = ConfigurableEntry(date: entryDate, configuration: configuration, joke: joke)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

}

struct ConfigurableEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let joke: Joke?
}

struct ConfigurableWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: ConfigurableWidgetProvider.Entry

    var body: some View {
        if let joke = entry.joke {
            Link(destination: URL(string: "s4m://joke/\(joke.id)-\(joke.category.rawValue)-\(joke.lang.rawValue)")!) {
                JokeView(joke: joke)
            }
        } else {
            let category = entry.configuration.category?.id ?? Category.Any.rawValue
            let language = entry.configuration.language?.id ?? Language.en.name
            ContentUnavailableView {
                Text("😢")
                    .font(.system(size: family == .systemLarge ? 120 : 80))
            } description: {
                Text("No Joke available for \(category) in \(language).")
                    .font(family == .systemLarge ? .largeTitle : .title2)
                    .fixedSize(horizontal: false, vertical: true)
            }

        }
    }
}

struct ConfigurableWidget: Widget {
    let kind: String = "ConfigurableWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: ConfigurableWidgetProvider()) { entry in
            
            ConfigurableWidgetEntryView(entry: entry)
                .meshBackground(entry.configuration.enabled)
                
        }
        .configurationDisplayName("Configurable Smile4Me")
        .description("Choose a language and category for your joke.")
        .supportedFamilies([.systemMedium,.systemLarge])
    }
}

#Preview("Medium Widget", as: .systemMedium) {
    ConfigurableWidget()
} timeline: {
    ConfigurableEntry(date: .now, configuration: ConfigurationAppIntent(), joke: Joke.single)
    ConfigurableEntry(date: .now, configuration: ConfigurationAppIntent(), joke: Joke.twopart)
}

#Preview("Large Widget", as: .systemLarge) {
    ConfigurableWidget()
} timeline: {
    ConfigurableEntry(date: .now, configuration: ConfigurationAppIntent(), joke: Joke.single)
    ConfigurableEntry(date: .now, configuration: ConfigurationAppIntent(), joke: Joke.twopart)
}

struct MeshBackground: ViewModifier {
    let enabled: Bool
    func body(content: Content) -> some View {
        if enabled {
            let meshBG = MeshGradient(
                width: 2,
                height: 2,
                points: [[0,0],[1,0],[0,1],[1,1]],
                colors: [.purple,.green,.teal,.orange]
            )
            content
                .containerBackground(meshBG, for: .widget)
        } else {
            content
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension View {
    func meshBackground(_ enabled: Bool) -> some View {
        modifier(MeshBackground(enabled: enabled))
    }
}
