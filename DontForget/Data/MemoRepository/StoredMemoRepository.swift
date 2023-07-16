//
//  StoredMemoRepository.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

final class StoredMemoRepository: MemoRepository {
    private enum Constant {
        static let key: String = "StoredMemo"
        static let maxLength: Int = 100
    }

    private var storedMemoList: [Memo] {
        get { UserDefaults.standard.array(forKey: Constant.key) as? [Memo] ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: Constant.key) }
    }

    var memoList: [Memo] {
        return storedMemoList
    }

    func createMemo(_ memo: Memo) async throws {
        let newList = (storedMemoList + [memo])
            .sorted(by: { $0.id > $1.id })
            .prefix(Constant.maxLength)

        storedMemoList = Array(newList)
    }

    func deleteMemo(_ memo: Memo) async throws {
        let newList = storedMemoList
            .filter { $0.id != memo.id }
        
        storedMemoList = newList
    }
}
