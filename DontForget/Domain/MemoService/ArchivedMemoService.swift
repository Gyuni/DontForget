//
//  ArchivedMemoService.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

final class ArchivedMemoService: MemoReadService, MemoDeleteService {
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
        return storedMemoRepository.memoList
            .filter { liveActivityMemoRepository.memoList.contains($0) == false }
    }

    func deleteMemo(_ memo: Memo) async throws {
        try await storedMemoRepository.deleteMemo(memo)
    }
}
