//
//  String+Helpers.swift
//  QRChild
//
//  Created by Karapats on 19/06/ 15.
//  Copyright © 2018 Karapats. All rights reserved.
//

import Foundation

extension String {
    
    public func substring(by pattern: String) -> String? {
        if let typeRange = self.range(of: pattern,
                                        options: .regularExpression) {
            print("First type: \(self[typeRange])")
            return String(self[typeRange])
        }
        return nil
    }
 
}
