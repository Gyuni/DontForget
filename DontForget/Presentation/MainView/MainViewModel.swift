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
    
    init(
        liveMemoService: MemoService,
        archivedMemoService: MemoService
    ) {
        self.liveMemoService = liveMemoService
        self.archivedMemoService = archivedMemoService
        self.liveMemoListViewModel = MemoListViewModel(service: liveMemoService)
        self.archivedMemoListViewModel = MemoListViewModel(service: archivedMemoService)
        self.memoInputViewModel = MemoInputViewModel(service: liveMemoService)
    }
}
