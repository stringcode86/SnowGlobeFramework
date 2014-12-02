//
//  NumberExtentios.swift
//  Brady's Videos
//
//  Created by Michal Inger on 14/09/2014.
//

import Foundation

protocol Summable { func +(lhs: Self, rhs: Self) -> Self }
protocol Multiplicable { func *(lhs: Self, rhs: Self) -> Self }

extension Int: Summable, Multiplicable {}
extension Double: Summable, Multiplicable {}
extension Float: Summable, Multiplicable {}

func sq<T: Multiplicable>(x: T) -> T {
    return x * x
}
