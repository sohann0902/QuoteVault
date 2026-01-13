//
//  QuoteService.swift
//  BrewApps
//
//  Created by Sohan Maurya on 13/01/26.
//

import Foundation

enum QuoteServiceError: LocalizedError {
    case invalidResponse
    case missingAPIKey

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Something went wrong. Please try again."
        case .missingAPIKey:
            return "Missing API key. Add it in APIConfig.apiKey."
        }
    }
}

protocol QuoteServicing {
    func fetchRandomQuote() async throws -> QuoteDTO
}

struct QuoteService: QuoteServicing {
    func fetchRandomQuote() async throws -> QuoteDTO {
        guard !APIConfig.apiKey.isEmpty else {
            throw QuoteServiceError.missingAPIKey
        }

        var request = URLRequest(url: APIConfig.baseURL)
        request.setValue(APIConfig.apiKey, forHTTPHeaderField: "X-Api-Key")
        request.timeoutInterval = 15

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw QuoteServiceError.invalidResponse
        }

        let decoded = try JSONDecoder().decode([QuoteAPIResponse].self, from: data)
        guard let first = decoded.first else {
            throw QuoteServiceError.invalidResponse
        }

        return QuoteDTO(text: first.quote, author: first.author)
    }
}
