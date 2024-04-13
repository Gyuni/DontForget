//
//  UIPasteBoardService.swift
//  DontForget
//
//  Created by Gyuni on 4/14/24.
//

import Foundation
import UIKit

final class UIPasteBoardService: ClipboardService {
    func copy(text: String) {
        UIPasteboard.general.string = text
    }
}
