//
//  MemoInputView.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation
import Combine
import SwiftUI

struct MemoInputView: View {
    @ObservedObject var viewModel: MemoInputViewModel

    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(uiColor: .secondarySystemFill))
            HStack(alignment: .bottom, spacing: 8) {
                VStack {
                    Spacer()
                        .frame(height: 2)
                    TextField(viewModel.placeholder, text: $viewModel.input, axis: .vertical)
                        .textFieldStyle(.plain)
                        .lineLimit(5)
                }
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                Button(action: { viewModel.onWriteButtonTap.send() }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.accentColor)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                .disabled(viewModel.writeButtonIsDisabled)
            }
            .padding()
        }.onAppear {
            viewModel.onAppear.send()
        }
    }
}
