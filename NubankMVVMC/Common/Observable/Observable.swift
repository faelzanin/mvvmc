//
//  Observable.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.

import UIKit

class Observable<T> {
    fileprivate var _value: T?
    var didChange: ((T) -> Void)?
    var value: T {
        set {
            _value = newValue
            didChange?(_value!)
        }
        get {
            return _value!
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    deinit {
        _value = nil
        didChange = nil
    }
}
