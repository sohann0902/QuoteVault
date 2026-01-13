//
//  QuoteDTO.swift
//  BrewApps
//
//  Created by Sohan Maurya on 13/01/26.
//

import Foundation

struct QuoteDTO: Identifiable, Equatable {
    let id: UUID
    let text: String
    let author: String

    init(id: UUID = UUID(), text: String, author: String) {
        self.id = id
        self.text = text
        self.author = author
    }
}

struct QuoteAPIResponse: Decodable {
    let quote: String
    let author: String
}
