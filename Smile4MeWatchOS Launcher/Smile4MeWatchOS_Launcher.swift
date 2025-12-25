//
//  Smile4MeWatchOS_Launcher.swift
//  Smile4MeWatchOS Launcher
//
//  Created by Weerawut on 25/12/2568 BE.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> LauncherEntry {
        LauncherEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (LauncherEntry) -> ()) {
        let entry = LauncherEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = LauncherEntry(date: currentDate)

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct LauncherEntry: TimelineEntry {
    let date: Date
}

struct Smile4MeWatchOS_LauncherEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        if family == .accessoryCircular {
            Image(.complication)
        } else {
            Text("Smile4Me")
            Image(.complication)
        }
    }
}

struct Smile4MeWatchOS_Launcher: Widget {
    let kind: String = "Smile4MeWatchOS_Launcher"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            
            Smile4MeWatchOS_LauncherEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Smile4Me App Launcher")
        .description("Launches this app from this icon.")
        .supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

#Preview("Regular", as: .accessoryRectangular) {
    Smile4MeWatchOS_Launcher()
} timeline: {
    LauncherEntry(date: .now)
}

#Preview("Circular", as: .accessoryCircular) {
    Smile4MeWatchOS_Launcher()
} timeline: {
    LauncherEntry(date: .now)
}

#Preview("Inline", as: .accessoryInline) {
    Smile4MeWatchOS_Launcher()
} timeline: {
    LauncherEntry(date: .now)
}
