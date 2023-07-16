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

    var memoList: [Memo] {
        return (try? getStoredMemoList()) ?? []
    }

    func createMemo(_ memo: Memo) async throws {
        let prevList = try getStoredMemoList()
        let newList = (prevList + [memo])
            .sorted(by: { $0.id > $1.id })
            .prefix(Constant.maxLength)

        try setStoredMemoList(Array(newList))
    }

    func deleteMemo(_ memo: Memo) async throws {
        let prevList = try getStoredMemoList()
        let newList = prevList
            .filter { $0.id != memo.id }

        try setStoredMemoList(Array(newList))
    }

    private func getStoredMemoList() throws -> [Memo] {
        guard let data = UserDefaults.standard.data(forKey: Constant.key) else {
            return []
        }

        return try Array<Memo>(from: data)
    }

    private func setStoredMemoList(_ list: [Memo]) throws {
        let data = try list.asData
        UserDefaults.standard.set(data, forKey: Constant.key)
    }

}

extension Array<Memo> {
    init(from data: Data) throws {
        self = try JSONDecoder().decode([Memo].self, from: data)
    }

    var asData: Data {
        get throws {
            try JSONEncoder().encode(self)
        }
    }
}
