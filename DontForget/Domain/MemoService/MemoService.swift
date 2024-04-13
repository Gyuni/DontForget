//
//  MemoService.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

protocol MemoService {
    var memoList: [Memo] { get }
    func createMemo(containing text: String) async throws
    func deleteMemo(_ memo: Memo) async throws
}
