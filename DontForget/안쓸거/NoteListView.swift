//
//  NoteListView.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/09.
//

//import Combine
//import SwiftUI
//
//struct NoteListView: View {
//    @ObservedObject var viewModel: NoteListViewModel
//    @State var selected: Int = 0
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 0) {
//                Spacer()
//                    .frame(height: 4)
//                Picker("type", selection: $selected) {
//                    Image(systemName: "note.text").tag(0)
//                    Image(systemName: "trash").tag(1)
//                }
//                .pickerStyle(.segmented)
//                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
//                List {
//                    ForEach(viewModel.noteList) { note in
//                        Text(note.text)
//                            .padding(8)
//                    }
//                    .onDelete(perform: viewModel.deleteNotes(at:))
//                }
//                .listStyle(.plain)
//                Rectangle()
//                    .frame(height: 0.5)
//                    .foregroundColor(Color(uiColor: .secondarySystemFill))
//                HStack(alignment: .bottom, spacing: 8) {
//                    VStack {
//                        Spacer()
//                            .frame(height: 2)
//                        TextField("", text: $viewModel.textInput, axis: .vertical)
//                            .textFieldStyle(.plain)
//                            .lineLimit(5)
//                    }
//                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
//                    .background(Color(uiColor: .secondarySystemBackground))
//                    .cornerRadius(12)
//                    Button(action: {
//                        viewModel.createNote()
//                    }, label: {
//                        Image(systemName: "plus.circle.fill")
//                            .font(.title)
//                            .fontWeight(.heavy)
//                            .foregroundColor(Color.accentColor)
//                    })
//                    .disabled(viewModel.isWriteButtonDisabled)
//                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
//                }
//                .padding()
//            }
//            .scrollDismissesKeyboard(.interactively)
//            .navigationTitle("Don't Forget")
//        }
//    }
//}
//
//#if DEBUG
//struct NoteListView_Previews: PreviewProvider {
//    static var previews: some View {
//        StubNoteService.shared.stubbedNoteList = [
//            NoteAttributes(text: "Vestibulum vitae orci id magna pellentesque bibendum ut et magna."),
//            NoteAttributes(text: "Nulla laoreet dolor enim, in consequat ipsum iaculis at."),
//            NoteAttributes(text: "Integer rutrum sagittis viverra. Sed blandit semper ex non dignissim."),
//            NoteAttributes(text: "Suspendisse orci lacus, posuere at lobortis volutpat, tincidunt et ipsum. Duis quis posuere eros."),
//            NoteAttributes(text: "Fusce convallis lacinia justo, at malesuada purus viverra vitae.")
//        ]
//        
//        return NoteListView(viewModel: NoteListViewModel(service: StubNoteService.shared))
//    }
//}
//#endif
