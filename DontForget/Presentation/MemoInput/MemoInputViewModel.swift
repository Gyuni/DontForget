//
//  MemoInputViewModel.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation
import Combine

final class MemoInputViewModel: ObservableObject {
    private let service: MemoService

    @Published var input: String = ""
    @Published var placeholder: String = ""
    @Published var writeButtonIsDisabled: Bool = true

    let memoDidWritten = PassthroughSubject<Void, Never>()
    let memoDidDeleted = PassthroughSubject<Void, Never>()

    let onAppear = PassthroughSubject<Void, Never>()
    let onWriteButtonTap = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(service: MemoService) {
        self.service = service

        let exceededLimit = onAppear
            .merge(with: memoDidWritten)
            .merge(with: memoDidDeleted)
            .merge(with: onAppear)
            .map { service.memoList.count >= 5 }

        exceededLimit
            .map { $0 ? "Maximum 5 memos allowed" : "" }
            .receive(on: DispatchQueue.main)
            .assign(to: \.placeholder, on: self)
            .store(in: &cancellables)

        let isInputEmpty = $input
            .map { $0 == "" }

        exceededLimit
            .combineLatest(isInputEmpty)
            .map { $0 || $1 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.writeButtonIsDisabled, on: self)
            .store(in: &cancellables)

        onWriteButtonTap
            .sink(receiveValue: { [weak self] _ in
                self?.writeMemo()
            })
            .store(in: &cancellables)

        memoDidWritten
            .map { "" }
            .receive(on: DispatchQueue.main)
            .assign(to: \.input, on: self)
            .store(in: &cancellables)
    }

    private func writeMemo() {
        Task {
            try? await service.createMemo(containing: input)
            memoDidWritten.send()
        }
    }
}
