//
//  MemoListView.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Combine
import SwiftUI

struct MemoListView: View {
    @ObservedObject var viewModel: MemoListViewModel
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        List {
            ForEach(viewModel.memoList) { memo in
                MemoView(memo: memo)
            }
            .onDelete { indexSet in
                viewModel.onMemoDelete.send(indexSet)
            }
        }
        .listStyle(.plain)
        .navigationBarItems(trailing: EditButton())
        .onAppear {
            viewModel.onAppear.send()
        }
        .onChange(of: scenePhase) { phase in
            guard phase == .active else { return }
            viewModel.onAppear.send()
        }
    }
}

struct MemoView: View {
    private let memo: Memo
    init(memo: Memo) {
        self.memo = memo
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(memo.text)
                .fontWeight(.semibold)
            Text(memo.createdAt.formatted())
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
    }
}
