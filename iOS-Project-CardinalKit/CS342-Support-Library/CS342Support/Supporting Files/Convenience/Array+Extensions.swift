//
//  Array+Extensions.swift
//  CS342Support
//
//  Created by Santiago Gutierrez on 11/12/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation

extension Array {
    public func grouped<T>(by criteria: (Element) -> T) -> [T: [Element]] {
        var groups = [T: [Element]]()
        for element in self {
            let key = criteria(element)
            if groups.keys.contains(key) == false {
                groups[key] = [Element]()
            }
            groups[key]?.append(element)
        }
        return groups
    }
}
