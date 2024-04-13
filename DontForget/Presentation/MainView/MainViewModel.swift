//
//  MainViewModel.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/17.
//

import Foundation
import Combine
import SwiftUI

enum MemoListType {
    static let description = "Memo List Type"

    case live
    case archived
    
    var image: Image {
        switch self {
        case .live:
            return Image(systemName: "note.text")
        case .archived:
            return Image(systemName: "trash")
        }
    }
}

final class MainViewModel: ObservableObject {
    @Published var selectedTab: MemoListType = .live

    private let liveMemoCreateService: MemoCreateService
    private let liveMemoReadService: MemoReadService
    private let liveMemoDeleteService: MemoDeleteService
    private let archivedMemoReadService: MemoReadService
    private let archivedMemoDeleteService: MemoDeleteService
    private let clipboardService: ClipboardService

    let liveMemoListViewModel: MemoListViewModel
    let archivedMemoListViewModel: MemoListViewModel
    let memoInputViewModel: MemoInputViewModel

    private var cancellables = Set<AnyCancellable>()

    init(
        liveMemoCreateService: MemoCreateService,
        liveMemoReadService: MemoReadService,
        liveMemoDeleteService: MemoDeleteService,
        archivedMemoReadService: MemoReadService,
        archivedMemoDeleteService: MemoDeleteService,
        clipboardService: ClipboardService,
        hapticFeedbackService: HapticFeedbackService
    ) {
        self.liveMemoCreateService = liveMemoCreateService
        self.liveMemoReadService = liveMemoReadService
        self.liveMemoDeleteService = liveMemoDeleteService
        self.archivedMemoReadService = archivedMemoReadService
        self.archivedMemoDeleteService = archivedMemoDeleteService
        self.clipboardService = clipboardService

        self.liveMemoListViewModel = MemoListViewModel(
            createService: liveMemoCreateService,
            readService: liveMemoReadService,
            deleteService: liveMemoDeleteService,
            clipboardService: clipboardService,
            hapticFeedbackService: hapticFeedbackService
        )
        self.archivedMemoListViewModel = MemoListViewModel(
            createService: liveMemoCreateService,
            readService: archivedMemoReadService,
            deleteService: archivedMemoDeleteService,
            clipboardService: clipboardService,
            hapticFeedbackService: hapticFeedbackService
        )
        self.memoInputViewModel = MemoInputViewModel(
            createService: liveMemoCreateService,
            readService: liveMemoReadService
        )

        liveMemoListViewModel.memoDidDeleted
            .merge(with: archivedMemoListViewModel.memoDidDeleted)
            .sink(receiveValue: { [weak self] in
                self?.memoInputViewModel.memoDidDeleted.send()
            })
            .store(in: &cancellables)

        memoInputViewModel.memoDidWritten
            .sink(receiveValue: { [weak self] in
                self?.liveMemoListViewModel.memoDidWritten.send()
                self?.archivedMemoListViewModel.memoDidWritten.send()
            })
            .store(in: &cancellables)
    }
}
