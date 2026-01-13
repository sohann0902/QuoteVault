//
//  WidgetRefresher.swift
//  BrewApps
//
//  Created by Sohan Maurya on 13/01/26.
//

import WidgetKit

enum WidgetRefresher {
    static func reloadQuotes() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
