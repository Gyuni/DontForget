//
//  StubbedMemoRepository.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

#if DEBUG
final class StubbedMemoRepository: MemoRepository {
    var stubbedMemoList: (() -> [Memo])!
    var memoList: [Memo] {
        stubbedMemoList()
    }

    var stubbedCreateMemo: ((Memo) async throws -> Void)!
    func createMemo(_ memo: Memo) async throws {
        try await stubbedCreateMemo(memo)
    }

    var stubbedDeleteMemo: ((Memo) async throws -> Void)!
    func deleteMemo(_ memo: Memo) async throws {
        try await stubbedDeleteMemo(memo)
    }
}
#endif
