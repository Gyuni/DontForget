//
//  LiveActivityMemoRepository.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import ActivityKit
import Foundation

final class LiveActivityMemoRepository: MemoRepository {
    var memoList: [Memo] {
        return Activity<MemoAttributes>.activities
            .map { Memo(from: $0) }
            .sorted(by: { $0.id > $1.id })
    }

    func createMemo(_ memo: Memo) async throws {
        _ = try Activity<MemoAttributes>.request(attributes: memo.asAttributes, content: memo.asContentState)
    }

    func deleteMemo(_ memo: Memo) async throws {
        let targets = Activity<MemoAttributes>.activities
            .filter { $0.attributes.id == memo.id }

        for target in targets {
            await target.end(nil, dismissalPolicy: .immediate)
        }
    }
}
