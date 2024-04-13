//
//  MemoInputViewModel.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation
import Combine
import SwiftUI

final class MemoInputViewModel: ObservableObject {
    private let createService: MemoCreateService
    private let readService: MemoReadService

    @Published var isFocused: Bool = false
    @Published var input: String = ""
    @Published var placeholder: String = ""
    @Published var writeButtonIsDisabled: Bool = true

    let memoDidWritten = PassthroughSubject<Void, Never>()
    let memoDidDeleted = PassthroughSubject<Void, Never>()

    let onAppear = PassthroughSubject<Void, Never>()
    let onWriteButtonTap = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(
        createService: MemoCreateService,
        readService: MemoReadService
    ) {
        self.createService = createService
        self.readService = readService

        onAppear.first()
            .sink(receiveValue: { [weak self] in
                self?.isFocused = true
            })
            .store(in: &cancellables)

        let exceededLimit = onAppear
            .merge(with: memoDidWritten)
            .merge(with: memoDidDeleted)
            .merge(with: onAppear)
            .map { createService.canCreate }

        exceededLimit
            .map { $0 ? "Maximum 5 memos allowed" : "A memo lasts for 8 hours" }
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
            try? await createService.createMemo(text: input)
            memoDidWritten.send()
        }
    }
}
