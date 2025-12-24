//
//  Smile4MeWidget.swift
//  Smile4MeWidget
//
//  Created by Weerawut on 24/12/2568 BE.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let jokeManager = JokeManager()
    
    func placeholder(in context: Context) -> JokeEntry {
        JokeEntry(date: Date(), joke: Joke.single)
    }
    
    //When adding the Widget
    func getSnapshot(in context: Context, completion: @escaping (JokeEntry) -> ()) {
        Task {
            let joke = try await jokeManager.getJoke()
            let entry = JokeEntry(date: Date(), joke: joke)
            completion(entry)
        }
    }
    
    //Real one after add the Widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [JokeEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            Task {
                let joke = try await jokeManager.getJoke()
                let entry = JokeEntry(date: entryDate, joke: joke)
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct JokeEntry: TimelineEntry {
    let date: Date
    let joke: Joke?
}

struct Smile4MeWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        if let joke = entry.joke {
            Link(destination: URL(string: "s4m://joke/\(joke.id)-\(joke.category.rawValue)-\(joke.lang.rawValue)")!) {
                JokeView(joke: joke)
            }
        } else {
            ContentUnavailableView {
                Text("😢")
                    .font(.system(size: family == .systemLarge ? 120 : 80))
            } description: {
                Text("No Joke available.")
                    .font(family == .systemLarge ? .largeTitle : .title2)
            }

        }
    }
}

struct Smile4MeWidget: Widget {
    let kind: String = "Smile4MeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Smile4MeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Smile4Me")
        .description("Bring a smile to your face.")
        .supportedFamilies([.systemMedium,.systemLarge])
    }
}

#Preview("Medium Widget", as: .systemMedium) {
    Smile4MeWidget()
} timeline: {
    JokeEntry(date: .now, joke: Joke.single)
    JokeEntry(date: .now, joke: Joke.twopart)
}

#Preview("Large Widget", as: .systemLarge) {
    Smile4MeWidget()
} timeline: {
    JokeEntry(date: .now, joke: Joke.single)
    JokeEntry(date: .now, joke: Joke.twopart)
}
