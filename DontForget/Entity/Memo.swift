//
//  Memo.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

struct Memo: Identifiable, Codable, Equatable {
    let id: UInt64

    let text: String
    let createdAt: Date
}

extension Memo {
    var asAttributes: MemoAttributes {
        return MemoAttributes(id: id, createdAt: createdAt)
    }
}
