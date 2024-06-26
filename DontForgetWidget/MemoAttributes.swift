//
//  MemoAttributes.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/09.
//

import ActivityKit
import Foundation

struct MemoAttributes: ActivityAttributes {
    let id: UInt64
    let createdAt: Date

    struct ContentState: Codable, Hashable {
        var text: String
    }
}
