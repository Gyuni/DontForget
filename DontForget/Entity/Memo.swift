//
//  Memo.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import ActivityKit
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

    var asContentState: ActivityContent<Activity<MemoAttributes>.ContentState> {
        .init(state: .init(text: text), staleDate: nil)
    }

    init(from activity: Activity<MemoAttributes>) {
        self.id = activity.attributes.id
        self.text = activity.content.state.text
        self.createdAt = activity.attributes.createdAt
    }
}
