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

    var body: some View {
        List {
            ForEach(viewModel.memoList) { memo in
                MemoView(memo: memo)
            }
            .onDelete { indexSet in
                viewModel.onMemoDelete.send(indexSet)
            }
        }
        .onAppear {
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
        Text(memo.text).padding(8)
    }
}
