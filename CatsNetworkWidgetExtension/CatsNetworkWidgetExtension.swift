//
//  CatsNetworkWidgetExtension.swift
//  CatsNetworkWidgetExtension
//
//  Created by Karina gurachevskaya on 22.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let midnight = Calendar.current.startOfDay(for: Date())
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [SimpleEntry(date: midnight)]
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CatsNetworkWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        URLImageWidgetEntryView(entry: entry)
    }
}

private struct URLImageWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        if let imageURL, let data = try? Data(contentsOf: imageURL) {
            URLImageView(data: data)
                .aspectRatio(contentMode: .fill)
        }
    }

    private var imageURL: URL? {
        let path = "https://raw.githubusercontent.com/pawello2222/country-flags/main/png1000px/pl.png"
        return URL(string: path)
    }
}

@main
struct CatsNetworkWidgetExtension: Widget {
    let kind: String = "CatsNetworkWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CatsNetworkWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Cats Widget")
        .description("This is a widget that shows what cat you are today.")
    }
}

struct CatsNetworkWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        CatsNetworkWidgetExtensionEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
