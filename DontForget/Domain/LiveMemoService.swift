//
//  LiveMemoService.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

final class LiveMemoService: MemoService {
    private let liveActivityMemoRepository: MemoRepository
    private let storedMemoRepository: MemoRepository

    init(
        liveActivityMemoRepository: MemoRepository,
        storedMemoRepository: MemoRepository
    ) {
        self.liveActivityMemoRepository = liveActivityMemoRepository
        self.storedMemoRepository = storedMemoRepository
    }

    var memoList: [Memo] {
        return liveActivityMemoRepository.memoList
    }

    func createMemo(_ memo: Memo) async throws {
        await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask { [weak self] in
                try await self?.liveActivityMemoRepository.createMemo(memo)
            }
            group.addTask { [weak self] in
                try await self?.storedMemoRepository.createMemo(memo)
            }
        }
    }

    func deleteMemo(_ memo: Memo) async throws {
        try await liveActivityMemoRepository.deleteMemo(memo)
    }
}
