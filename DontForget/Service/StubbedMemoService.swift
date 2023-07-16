//
//  StubbedMemoService.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

#if DEBUG
class StubbedMemoService: MemoRepository {
    private init() { }

    var stubbedMemoList: [Memo]!
    var memoList: [Memo] {
        return stubbedMemoList
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

