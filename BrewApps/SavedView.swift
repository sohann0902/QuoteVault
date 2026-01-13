//
//  SavedView.swift
//  BrewApps
//
//  Created by Sohan Maurya on 13/01/26.
//

import SwiftUI
import CoreData

struct SavedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Quote.fetchRequestAll())
    private var quotes: FetchedResults<Quote>

    @State private var shareItem: ShareItem?

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()

            if quotes.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(quotes) { quote in
                        SavedQuoteRow(quote: quote) {
                            let text = quote.text ?? ""
                            let author = quote.author ?? ""
                            shareItem = ShareItem(text: "\"\(text)\" — \(author)")
                        } favoriteAction: {
                            toggleFavorite(quote)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 10)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteQuote(quote)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .padding(.top, 8)
            }
        }
        .sheet(item: $shareItem) { item in
            ShareSheet(activityItems: [item.text])
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.7))
            Text("No saved quotes yet")
                .font(.custom("Avenir Next", size: 18))
                .foregroundStyle(Color.white)
            Text("Save your favorites from Home and they’ll appear here.")
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
    }

    private func toggleFavorite(_ quote: Quote) {
        quote.isFavorite.toggle()
        saveContext()
    }

    private func deleteQuote(_ quote: Quote) {
        viewContext.delete(quote)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
            WidgetRefresher.reloadQuotes()
        } catch {
            viewContext.rollback()
        }
    }
}

private struct SavedQuoteRow: View {
    @ObservedObject var quote: Quote
    let shareAction: () -> Void
    let favoriteAction: () -> Void

    var body: some View {
        Button(action: shareAction) {
            ZStack(alignment: .bottomTrailing) {
                QuoteCardView(
                    text: quote.text ?? "",
                    author: quote.author ?? ""
                )

                Button(action: favoriteAction) {
                    Image(systemName: quote.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(width: 34, height: 34)
                        .background(AppTheme.accent.opacity(0.9))
                        .clipShape(Circle())
                }
                .padding(16)
                .buttonStyle(.plain)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SavedView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
