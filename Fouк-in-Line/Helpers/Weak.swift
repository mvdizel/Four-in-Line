//
//  Weak.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 5/13/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

struct Weak<T: AnyObject> {
    
    // MARK: - Public Instance Attributes
    fileprivate(set) weak var value: T?
    
    
    // MARK: - Initializers
    init(_ value: T) {
        self.value = value
    }
    
    @available(*, unavailable) init() {
        fatalError("unavailable")
    }
}
