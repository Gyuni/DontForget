//
//  MemoService.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

protocol MemoReadService {
    var memoList: [Memo] { get }
}

protocol MemoCreateService {
    var canCreate: Bool { get }
    func createMemo(text: String) async throws
}

protocol MemoDeleteService {
    func deleteMemo(_ memo: Memo) async throws
}
