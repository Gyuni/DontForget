//
//  ClipboardService.swift
//  DontForget
//
//  Created by Gyuni on 4/14/24.
//

import Foundation

protocol ClipboardService {
    func copy(text: String) async throws
}
