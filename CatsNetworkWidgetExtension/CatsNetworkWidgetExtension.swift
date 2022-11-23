//
//  CatsNetworkWidgetExtension.swift
//  CatsNetworkWidgetExtension
//
//  Created by Karina gurachevskaya on 22.11.22.
//

import WidgetKit
import SwiftUI
import Intents
import Combine

private var cancellables = Set<AnyCancellable>()

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        
        NetworkManager.shared.fetch(endpoint: CatAPIEndpoint.getRandomCatImage)
            .receive(on: DispatchQueue.main)
            .decode(type: [CatModel].self, decoder: JSONDecoder())
            .map { $0.first }
            .sink {
                switch $0 {
                case .failure(let error):
                    print(error.localizedDescription)
                    let entries = [
                        SimpleEntry(date: currentDate),
                        SimpleEntry(date: nextDate),
                    ]
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                           completion(timeline)
                       case .finished:
                           print("Request completed")
                       }
                   } receiveValue: {
                       let entries = [
                           SimpleEntry(date: currentDate, cat: $0),
                           SimpleEntry(date: nextDate, cat: $0),
                       ]
                       let timeline = Timeline(entries: entries, policy: .atEnd)
                       completion(timeline)
                   }
                   .store(in: &cancellables)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var cat: CatModel?
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
        if
            let imageURL = URL(string: entry.cat?.url ?? ""),
            let data = try? Data(contentsOf: imageURL)
        {
            URLImageView(data: data)
                .aspectRatio(contentMode: .fill)
        }
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
