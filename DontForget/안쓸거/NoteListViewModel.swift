//
//  NoteListViewModel.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/09.
//

//import Foundation
//import Combine
//
//class NoteListViewModel: ObservableObject {
//    private let service: NoteService
//
//    @Published var noteList: [NoteAttributes]
//    @Published var isWriteButtonDisabled: Bool = true
//    @Published var textInput: String
//
//    private var cancellables = Set<AnyCancellable>()
//
//    init(service: NoteService = DefaultNoteService()) {
//        self.service = service
//        self.noteList = service.noteList
//        self.textInput = ""
//        
//        $textInput
//            .map { $0.isEmpty }
//            .assign(to: \.isWriteButtonDisabled, on: self)
//            .store(in: &cancellables)
//    }
//
//    func deleteNotes(at indexSet: IndexSet) {
//        let targets: [NoteAttributes] = Array(indexSet).map { noteList[$0] }
//
//        Task {
//            for target in targets {
//                await service.deleteNote(target)
//            }
//            noteList = service.noteList
//        }
//    }
//
//    func createNote() {
//        Task {
//            try? service.createNote(NoteAttributes(text: textInput))
//            await MainActor.run {
//                noteList = service.noteList
//            }
//        }
//    }
//}
