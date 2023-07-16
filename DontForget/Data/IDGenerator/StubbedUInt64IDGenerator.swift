//
//  StubbedUInt64IDGenerator.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/16.
//

#if DEBUG
final class StubbedUInt64IDGenerator: IDGenerator {
    typealias IDType = UInt64

    var stubbedGenerate: (() async -> UInt64)!
    func generate() async -> UInt64 {
        await stubbedGenerate()
    }
}
#endif

