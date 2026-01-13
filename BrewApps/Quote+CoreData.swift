//
//  Quote+CoreData.swift
//  BrewApps
//
//  Created by Sohan Maurya on 13/01/26.
//

import CoreData

extension Quote {
    static func fetchRequestAll() -> NSFetchRequest<Quote> {
        let request = NSFetchRequest<Quote>(entityName: "Quote")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Quote.dateSaved, ascending: false)]
        return request
    }

    static func fetchRequestFavorites() -> NSFetchRequest<Quote> {
        let request = NSFetchRequest<Quote>(entityName: "Quote")
        request.predicate = NSPredicate(format: "isFavorite == YES")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Quote.dateSaved, ascending: false)]
        return request
    }
}
