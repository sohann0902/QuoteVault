//
//  QuoteCardView.swift
//  BrewApps
//
//  Created by Sohan Maurya on 13/01/26.
//

import SwiftUI

struct QuoteCardView: View {
    let text: String
    let author: String
    var allowScroll: Bool = false
    var showBackgroundImage: Bool = false
    var backgroundImageName: String? = nil

    var body: some View {
        ZStack {
            if showBackgroundImage, let backgroundImageName {
                Image(backgroundImageName)
                    .resizable()
                    .scaledToFill()
                    .overlay(Color.black.opacity(0.35))
            } else {
                AppTheme.cardGradient
            }

            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Color.white.opacity(0.35))

                Group {
                    if allowScroll {
                        ScrollView {
                            Text(text)
                                .font(.custom("Avenir Next", size: 20))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .scrollIndicators(.visible)
                        .frame(maxHeight: 140)
                    } else {
                        Text(text)
                            .font(.custom("Avenir Next", size: 20))
                            .foregroundStyle(Color.white)
                            .lineLimit(6)
                    }
                }

                Text(author.uppercased())
                    .font(.custom("Avenir Next", size: 12))
                    .foregroundStyle(AppTheme.secondaryText)
                    .tracking(1.2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
