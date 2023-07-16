//
//  Memo.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

struct Memo: Identifiable, Codable, Equatable {
    let id: Int

    let text: String
    let createdAt: Date
}
