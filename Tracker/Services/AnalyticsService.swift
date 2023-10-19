//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Вадим Шишков on 12.10.2023.
//

import YandexMobileMetrica
import Foundation

final class AnalyticsService {
    
    enum Parameters: String {
        case event
        case screen
        case item
    }

    enum Event: String {
        case open
        case closed
        case click
    }

    enum Screen: String {
        case statistics
        case main
        case filters
        case new_tracker
        case setup_tracker
        case setup_event
        case categories
        case new_category
        case schedule
    }

    enum Item: String {
        case add_track
        case add_category
        case track
        case filter
        case edit
        case delete
        case pin
        case new_tracker
        case new_event
        case cancel_button
        case create_button
        case textfield
        case hide_keyboard
        case clear_textfield
        case category
        case schedule
        case emoji
        case color
        case context_menu
        case done
    }
    
    enum Filter: String {
        case all
        case completed
        case incomplete
        case today
    }
    
    static let shared = AnalyticsService()
    private init() {}
    
    func sendEvent(params: [AnyHashable : Any]) {
        
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        
    }
}
