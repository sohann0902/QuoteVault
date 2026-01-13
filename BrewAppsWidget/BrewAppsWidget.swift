//
//  BrewAppsWidget.swift
//  BrewAppsWidget
//
//  Created by Sohan Maurya on 13/01/26.
//

import CoreData
import SwiftUI
import WidgetKit

private struct WidgetQuote: Equatable {
    let text: String
    let author: String
}

private struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: WidgetQuote?
}

private struct QuoteProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quote: WidgetQuote(text: "Stay hungry, stay foolish.", author: "Steve Jobs"))
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        completion(QuoteEntry(date: Date(), quote: loadFavoriteQuote()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let entry = QuoteEntry(date: Date(), quote: loadFavoriteQuote())
        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date().addingTimeInterval(86400)
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadFavoriteQuote() -> WidgetQuote? {
        guard let storeURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: AppGroup.identifier)?
            .appendingPathComponent("BrewApps.sqlite") else {
            return nil
        }

        let container = NSPersistentContainer(name: "BrewApps")
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]

        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }

        guard loadError == nil else {
            return nil
        }

        let context = container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Quote")
        request.predicate = NSPredicate(format: "isFavorite == YES")
        request.sortDescriptors = [NSSortDescriptor(key: "dateSaved", ascending: false)]
        request.fetchLimit = 1

        do {
            let result = try context.fetch(request).first
            guard let result else { return nil }
            let text = result.value(forKey: "text") as? String ?? ""
            let author = result.value(forKey: "author") as? String ?? ""
            guard !text.isEmpty else { return nil }
            return WidgetQuote(text: text, author: author.isEmpty ? "Unknown" : author)
        } catch {
            return nil
        }
    }
}

private struct BrewAppsWidgetEntryView: View {
    let entry: QuoteEntry

    var body: some View {
        ZStack {

            VStack(alignment: .leading, spacing: 8) {
                if let quote = entry.quote {
                    Text(quote.text)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .lineLimit(4)

                    Text(quote.author.uppercased())
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.7))
                        .tracking(1)
                } else {
                    Text("Save a quote to show it here")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.white)
                    Text("Favorite one for the widget")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.7))
                }

                Spacer(minLength: 0)
            }
            .padding(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(Color(red: 0.20, green: 0.14, blue: 0.38), for: .widget)
        
    }
}

struct BrewAppsWidget: Widget {
    private let kind = "BrewAppsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            BrewAppsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Favorite Quote")
        .description("Shows your saved favorite quote.")
        .supportedFamilies([.systemSmall, .systemMedium])
    
    }
}

#Preview(as: .systemSmall) {
    BrewAppsWidget()
} timeline: {
    QuoteEntry(date: Date(), quote: WidgetQuote(text: "Stay hungryyyy, stay foolish.", author: "Steve Jobs"))
}
