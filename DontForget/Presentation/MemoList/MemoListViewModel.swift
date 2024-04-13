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
    private let createService: MemoCreateService
    private let readService: MemoReadService
    private let deleteService: MemoDeleteService
    private let clipboardService: ClipboardService
    private let hapticFeedbackService: HapticFeedbackService

    @Published var memoList: [Memo] = []
    @Published var isDuplicateContextMenuDisabled: Bool = true

    let onAppear = PassthroughSubject<Void, Never>()
    let memoDidWritten = PassthroughSubject<Void, Never>()
    let memoDidDeleted = PassthroughSubject<Void, Never>()
    let onMemoSwipeDelete = PassthroughSubject<IndexSet, Never>()

    let onCopyContextMenuTap = PassthroughSubject<Memo, Never>()
    let onDuplicateContextMenuTap = PassthroughSubject<Memo, Never>()
    let onDeleteContextMenuTap = PassthroughSubject<Memo, Never>()
    
    let onDeleteAllButtonTap = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(
        createService: MemoCreateService,
        readService: MemoReadService,
        deleteService: MemoDeleteService,
        clipboardService: ClipboardService,
        hapticFeedbackService: HapticFeedbackService
    ) {
        self.createService = createService
        self.readService = readService
        self.deleteService = deleteService
        self.clipboardService = clipboardService
        self.hapticFeedbackService = hapticFeedbackService

        let memoListDidChanged = onAppear
            .merge(with: memoDidWritten)
            .merge(with: memoDidDeleted)
            .share()
        
        memoListDidChanged
            .map { readService.memoList }
            .receive(on: DispatchQueue.main)
            .assign(to: \.memoList, on: self)
            .store(in: &cancellables)

        memoListDidChanged
            .map { createService.canCreate }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isDuplicateContextMenuDisabled, on: self)
            .store(in: &cancellables)

        onMemoSwipeDelete
            .sink(receiveValue: { [weak self] indexSet in
                self?.deleteMemos(at: indexSet)
            })
            .store(in: &cancellables)

        onCopyContextMenuTap
            .sink(receiveValue: { [weak self] memo in
                self?.copyMemoToClipboard(memo)
            })
            .store(in: &cancellables)

        onDuplicateContextMenuTap
            .sink(receiveValue: { [weak self] memo in
                self?.createMemo(text: memo.text)
            })
            .store(in: &cancellables)

        onDeleteContextMenuTap
            .sink(receiveValue: { [weak self] memo in
                self?.deleteMemo(memo)
            })
            .store(in: &cancellables)

        onDeleteAllButtonTap
            .sink(receiveValue: { [weak self] in
                self?.deleteAllMemos()
            })
            .store(in: &cancellables)
    }

    private func createMemo(text: String) {
        Task {
            do {
                try await createService.createMemo(text: text)
                hapticFeedbackService.generateSuccessFeedback()
            } catch {
                
            }

            memoDidWritten.send()
        }
    }

    private func deleteAllMemos() {
        deleteMemos(at: IndexSet(integersIn: memoList.indices))
    }

    private func deleteMemos(at indexSet: IndexSet) {
        let targets: [Memo] = Array(indexSet).compactMap { memoList[safe: $0] }

        Task {
            for target in targets {
                try? await deleteService.deleteMemo(target)
            }

            memoDidDeleted.send()
        }
    }

    private func deleteMemo(_ memo: Memo) {
        Task {
            try? await deleteService.deleteMemo(memo)
            memoDidDeleted.send()
        }
    }

    private func copyMemoToClipboard(_ memo: Memo) {
        Task {
            do {
                try await clipboardService.copy(text: memo.text)
                hapticFeedbackService.generateSuccessFeedback()
            } catch {
                
            }
        }
    }
}
