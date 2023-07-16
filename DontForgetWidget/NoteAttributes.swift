//
//  NoteAttributes.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/09.
//

import ActivityKit
import Foundation

struct NoteAttributes: ActivityAttributes, Identifiable, Equatable {
    struct ContentState: Codable, Hashable {
        var value: Int
    }

    var text: String
    var id: String { text }
}
