//
//  LiveMemoService.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

final class LiveMemoService: MemoCreateService, MemoReadService, MemoDeleteService {
    private let liveActivityMemoRepository: MemoRepository
    private let storedMemoRepository: MemoRepository
    private let idGenerator: any IDGenerator<UInt64>

    init(
        liveActivityMemoRepository: MemoRepository,
        storedMemoRepository: MemoRepository,
        idGenerator: any IDGenerator<UInt64>
    ) {
        self.liveActivityMemoRepository = liveActivityMemoRepository
        self.storedMemoRepository = storedMemoRepository
        self.idGenerator = idGenerator
    }

    var memoList: [Memo] {
        return liveActivityMemoRepository.memoList
    }

    var canCreate: Bool {
        memoList.count >= 5 
    }

    func createMemo(text: String) async throws {
        let id = await idGenerator.generate()
        let memo = Memo(id: id, text: text, createdAt: .now)

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
