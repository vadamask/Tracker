//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Вадим Шишков on 12.10.2023.
//

import YandexMobileMetrica
import Foundation

final class AnalyticsService {
    
    static let shared = AnalyticsService()
    private init() {}
    
    func sendEvent(params: [AnyHashable : Any]) {
        
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        
    }
}
