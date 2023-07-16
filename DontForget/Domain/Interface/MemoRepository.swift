//
//  MemoRepository.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

protocol MemoRepository {
    var memoList: [Memo] { get }
    func createMemo(_ memo: Memo) async throws
    func deleteMemo(_ memo: Memo) async throws
}
