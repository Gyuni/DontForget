//
//  DateBasedIDGenerator.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

final class DateBasedIDGenerator: IDGenerator {
    typealias IDType = UInt64

    func generate() async -> UInt64 {
        return UInt64(Date().timeIntervalSince1970 * 1000)
    }
}
