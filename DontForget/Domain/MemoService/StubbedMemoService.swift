//
//  StubbedMemoService.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

#if DEBUG
final class StubbedMemoService: MemoService {
    var stubbedMemoList: (() -> [Memo])!
    var memoList: [Memo] {
        stubbedMemoList()
    }

    var stubbedCreateMemo: ((String) async throws -> Void)!
    func createMemo(containing text: String) async throws {
        try await stubbedCreateMemo(text)
    }

    var stubbedDeleteMemo: ((Memo) async throws -> Void)!
    func deleteMemo(_ memo: Memo) async throws {
        try await stubbedDeleteMemo(memo)
    }
}
#endif

