//
//  LiveMemoServiceTests.swift
//  DontForgetTests
//
//  Created by Gyuni on 2023/07/16.
//

import XCTest
import Shortcuts
@testable import DontForget

final class LiveMemoServiceTests: XCTestCase {
    
    private var liveActivityMemoRepository: StubbedMemoRepository!
    private var storedMemoRepository: StubbedMemoRepository!
    private var service: LiveMemoService!

    override func setUpWithError() throws {
        self.liveActivityMemoRepository = StubbedMemoRepository()
        self.storedMemoRepository = StubbedMemoRepository()
        self.service = LiveMemoService(
            liveActivityMemoRepository: liveActivityMemoRepository,
            storedMemoRepository: storedMemoRepository,
            idGenerator: StubbedUInt64IDGenerator()
        )
    }

    override func tearDownWithError() throws {
        self.liveActivityMemoRepository = nil
        self.storedMemoRepository = nil
        self.service = nil
    }

    func test_ReadMemoList() async throws {
        //  given
        let now = Date.now
        let memo = Memo(id: 0, text: "", createdAt: now)
        liveActivityMemoRepository.stubbedMemoList = { [memo] }

        //  when
        let expected = [memo]
        let result = service.memoList

        //  then
        XCTAssertEqual(expected, result)
    }
    
    func test_CreateMemoList() async throws {
        //  given
        let storedMemoRepositoryCreateMemoFuncDidExecute = XCTestExpectation()
        storedMemoRepository.stubbedCreateMemo = { _ in
            try! await Task.sleep(for: .milliseconds(100))
            storedMemoRepositoryCreateMemoFuncDidExecute.fulfill()
        }

        let liveActivityMemoRepositoryCreateMemoFuncDidExecute = XCTestExpectation()
        liveActivityMemoRepository.stubbedCreateMemo = { _ in
            try! await Task.sleep(for: .milliseconds(150))
            liveActivityMemoRepositoryCreateMemoFuncDidExecute.fulfill()
        }

        //  when
        Task {
            try await service.createMemo(text: "")
        }
        
        //  then
        await fulfillment(
            of: [storedMemoRepositoryCreateMemoFuncDidExecute,
                 liveActivityMemoRepositoryCreateMemoFuncDidExecute],
            timeout: .seconds(200),
            enforceOrder: true
        )
    }

    func test_DeleteMemoList() async throws {
        //  given
        let storedMemoRepositoryDeleteMemoFuncDidExecute = XCTestExpectation().then {
            $0.isInverted = true
        }
        storedMemoRepository.stubbedDeleteMemo = { _ in
            storedMemoRepositoryDeleteMemoFuncDidExecute.fulfill()
        }

        let liveActivityMemoRepositoryDeleteMemoFuncDidExecute = XCTestExpectation()
        liveActivityMemoRepository.stubbedDeleteMemo = { _ in
            liveActivityMemoRepositoryDeleteMemoFuncDidExecute.fulfill()
        }

        //  when
        Task {
            try await service.deleteMemo(Memo(id: 0, text: "", createdAt: .now))
        }

        //  then
        await fulfillment(
            of: [storedMemoRepositoryDeleteMemoFuncDidExecute,
                 liveActivityMemoRepositoryDeleteMemoFuncDidExecute],
            timeout: .milliseconds(1),
            enforceOrder: false
        )
    }
}
