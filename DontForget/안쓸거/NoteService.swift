//
//  NoteService.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/09.
//

import ActivityKit
import Foundation

protocol NoteService {
    var noteList: [NoteAttributes] { get }
    func createNote(_ attributes: NoteAttributes) throws
    func deleteNote(_ attributes: NoteAttributes) async
}

class DefaultNoteService: NoteService {
    var noteList: [NoteAttributes] { Activity<NoteAttributes>.activities.map { $0.attributes } }

    func createNote(_ attributes: NoteAttributes) throws {
        _ = try Activity<NoteAttributes>.request(
            attributes: attributes,
            content: .init(state: .init(value: 0), staleDate: nil)
        )
    }
    
    func deleteNote(_ attributes: NoteAttributes) async {
        await Activity<NoteAttributes>.activities
            .first(where: { $0.attributes == attributes })?
            .end(nil, dismissalPolicy: .immediate)
    }
}

#if DEBUG
class StubNoteService: NoteService {
    private init() { }
    static let shared = StubNoteService()

    var stubbedNoteList: [NoteAttributes]!
    var noteList: [NoteAttributes] { stubbedNoteList }

    func createNote(_ attributes: NoteAttributes) throws { }

    func deleteNote(_ attributes: NoteAttributes) async { }
}
#endif
