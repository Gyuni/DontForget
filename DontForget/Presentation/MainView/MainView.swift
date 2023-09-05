//
//  MainView.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/17.
//

import Foundation
import Combine
import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.selectedTab {
            case .live:
                MemoListView(viewModel: viewModel.liveMemoListViewModel)
                MemoInputView(viewModel: viewModel.memoInputViewModel)
            case .archived:
                MemoListView(viewModel: viewModel.archivedMemoListViewModel)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Picker(MemoListType.description, selection: $viewModel.selectedTab) {
                    MemoListType.live.image.tag(MemoListType.live)
                    MemoListType.archived.image.tag(MemoListType.archived)
                }
                .pickerStyle(.segmented)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Don't Forget")
    }
}
