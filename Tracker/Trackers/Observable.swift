//
//  Observable.swift
//  Tracker
//
//  Created by Вадим Шишков on 25.09.2023.
//

import Foundation

@propertyWrapper
final class Observable<T> {
    
    var onChange: ((T) -> Void)?
    
    var wrappedValue: T {
        didSet {
            onChange?(wrappedValue)
        }
    }
    
    var projectedValue: Observable<T> {
        return self
    }
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    func bind(action: @escaping (T) -> Void) {
        onChange = action
    }
}
