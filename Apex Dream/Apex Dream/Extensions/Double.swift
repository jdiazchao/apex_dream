//
//  Double.swift
//  Apex Dream
//
//  Created by Jorge Díaz Chao on 31/3/21.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
