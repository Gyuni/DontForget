//
//  MemoListViewModel.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation
import Combine
import Shortcuts

final class MemoListViewModel: ObservableObject {
    private let service: MemoService

    @Published var memoList: [Memo] = []

    let onAppear = PassthroughSubject<Void, Never>()
    let memoDidWritten = PassthroughSubject<Void, Never>()
    let memoDidDeleted = PassthroughSubject<Void, Never>()
    let onMemoDelete = PassthroughSubject<IndexSet, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(service: MemoService) {
        self.service = service

        onAppear
            .merge(with: memoDidWritten)
            .merge(with: memoDidDeleted)
            .map { service.memoList }
            .receive(on: DispatchQueue.main)
            .assign(to: \.memoList, on: self)
            .store(in: &cancellables)

        onMemoDelete
            .sink(receiveValue: { [weak self] indexSet in
                self?.deleteMemo(at: indexSet)
            })
            .store(in: &cancellables)
    }

    private func deleteMemo(at indexSet: IndexSet) {
        let targets: [Memo] = Array(indexSet).compactMap { memoList[safe: $0] }

        Task {
            for target in targets {
                try? await service.deleteMemo(target)
            }

            memoDidDeleted.send()
        }
    }
}
