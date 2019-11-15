//
//  Utils.swift
//  CS342Support
//
//  Created by Santiago Gutierrez on 11/12/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import HealthKit

extension HKSource {
    public var key: String {
        return "\(self.bundleIdentifier)"
    }
}

extension HKDevice {
    public var key: String? {
        guard let hardwareVersion = self.hardwareVersion else {
            
            return nil
        }
        
        return "\(hardwareVersion)"
    }
    
    public func getKey(appendSource source: HKSource? = nil) -> String {
        let result = self.key ?? "UnknownDevice"
        
        if let source = source {
            return "\(result) (\(source.key))"
        }
        
        return result
    }
}
