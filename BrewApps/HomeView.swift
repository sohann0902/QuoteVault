//
//  HomeView.swift
//  BrewApps
//
//  Created by Sohan Maurya on 13/01/26.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = HomeViewModel()
    @State private var shareItem: ShareItem?

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer(minLength: 12)

                ZStack {
                    if let quote = viewModel.quote {
                        QuoteCardView(text: quote.text, author: quote.author, allowScroll: true)
                            .transition(.opacity.combined(with: .scale))
                    } else if let message = viewModel.errorMessage {
                        QuoteCardView(text: "Couldn’t load a quote", author: "Tap next to retry", allowScroll: true)
                            .overlay(
                                Text(message)
                                    .font(.custom("Avenir Next", size: 14))
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 28),
                                alignment: .bottomLeading
                            )
                    } else {
                        QuoteCardView(text: "Fetching a new quote...", author: "Please wait", allowScroll: true)
                            .redacted(reason: .placeholder)
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .tint(Color.white)
                            .scaleEffect(1.2)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .padding(.horizontal, 24)

                HStack(spacing: 28) {
                    actionButton(icon: "heart.fill", title: "SAVE") {
                        viewModel.saveQuote(in: viewContext)
                    }

                    actionButton(icon: "arrow.clockwise", title: "NEXT") {
                        Task { await viewModel.fetchQuote() }
                    }

                    actionButton(icon: "square.and.arrow.up", title: "SHARE") {
                        if let quote = viewModel.quote {
                            shareItem = ShareItem(text: "\"\(quote.text)\" — \(quote.author)")
                        }
                    }
                }
                .padding(.bottom, 12)

                Spacer(minLength: 24)
            }
        }
        .task {
            if viewModel.quote == nil {
                await viewModel.fetchQuote()
            }
        }
        .sheet(item: $shareItem) { item in
            ShareSheet(activityItems: [item.text])
        }
    }

    private func actionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
                Text(title)
                    .font(.custom("Avenir Next", size: 10))
                    .foregroundStyle(AppTheme.secondaryText)
                    .tracking(1.2)
            }
        }
        .foregroundStyle(Color.white)
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
