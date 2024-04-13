//
//  IDGenerator.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

import Foundation

protocol IDGenerator<IDType> {
    associatedtype IDType
    func generate() async -> IDType
}
