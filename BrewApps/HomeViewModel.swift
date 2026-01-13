//
//  HomeViewModel.swift
//  BrewApps
//
//  Created by Sohan Maurya on 13/01/26.
//

import CoreData
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var quote: QuoteDTO?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: QuoteServicing

    init(service: QuoteServicing = QuoteService()) {
        self.service = service
    }

    func fetchQuote() async {
        isLoading = true
        errorMessage = nil
        withAnimation(.easeInOut(duration: 0.2)) {
            quote = nil
        }
        do {
            let result = try await service.fetchRandomQuote()
            withAnimation(.easeInOut(duration: 0.35)) {
                quote = result
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func saveQuote(in context: NSManagedObjectContext) {
        guard let quote else { return }

        let request = NSFetchRequest<Quote>(entityName: "Quote")
        request.predicate = NSPredicate(format: "text == %@ AND author == %@", quote.text, quote.author)
        request.fetchLimit = 1

        if let existing = try? context.fetch(request).first {
            existing.dateSaved = Date()
        } else {
            let entity = Quote(context: context)
            entity.id = quote.id
            entity.text = quote.text
            entity.author = quote.author
            entity.isFavorite = false
            entity.dateSaved = Date()
        }

        do {
            try context.save()
            WidgetRefresher.reloadQuotes()
        } catch {
            errorMessage = "Could not save quote."
        }
    }
}
