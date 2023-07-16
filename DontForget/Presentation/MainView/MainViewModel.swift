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
    
    private let liveMemoService: MemoService
    private let archivedMemoService: MemoService

    let liveMemoListViewModel: MemoListViewModel
    let archivedMemoListViewModel: MemoListViewModel
    let memoInputViewModel: MemoInputViewModel

    private var cancellables = Set<AnyCancellable>()

    init(
        liveMemoService: MemoService,
        archivedMemoService: MemoService
    ) {
        self.liveMemoService = liveMemoService
        self.archivedMemoService = archivedMemoService

        self.liveMemoListViewModel = MemoListViewModel(service: liveMemoService)
        self.archivedMemoListViewModel = MemoListViewModel(service: archivedMemoService)
        self.memoInputViewModel = MemoInputViewModel(service: liveMemoService)

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
