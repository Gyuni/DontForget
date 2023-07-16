//
//  ArchivedMemoService.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

final class ArchivedMemoService: MemoService {
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

    func createMemo(containing _: String) async throws {
        assertionFailure("""
        메모 저장은 LiveMemoService에서 메모를 생성할 때 해야합니다.
        ArchivedMemoService에서 단독으로 저장하면 안됩니다.
        """)
    }

    func deleteMemo(_ memo: Memo) async throws {
        try await storedMemoRepository.deleteMemo(memo)
    }
}
