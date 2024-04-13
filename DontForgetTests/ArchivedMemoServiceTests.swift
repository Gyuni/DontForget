//
//  ArchivedMemoServiceTests.swift
//  DontForgetTests
//
//  Created by Gyuni on 2023/07/16.
//

import XCTest
import Shortcuts
@testable import DontForget

final class ArchivedMemoServiceTests: XCTestCase {
    
    private var liveActivityMemoRepository: StubbedMemoRepository!
    private var storedMemoRepository: StubbedMemoRepository!
    private var service: ArchivedMemoService!

    override func setUpWithError() throws {
        self.liveActivityMemoRepository = StubbedMemoRepository()
        self.storedMemoRepository = StubbedMemoRepository()
        self.service = ArchivedMemoService(
            liveActivityMemoRepository: liveActivityMemoRepository,
            storedMemoRepository: storedMemoRepository
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
        let firstMemo = Memo(id: 1, text: "", createdAt: now)
        let secondMemo = Memo(id: 2, text: "", createdAt: now)
        let thirdMemo = Memo(id: 3, text: "", createdAt: now)
        liveActivityMemoRepository.stubbedMemoList = { [secondMemo] }
        storedMemoRepository.stubbedMemoList = { [thirdMemo, secondMemo, firstMemo] }

        //  when
        let expected = [thirdMemo, firstMemo]
        let result = service.memoList

        //  then
        XCTAssertEqual(expected, result)
    }

    func test_DeleteMemoList() async throws {
        //  given
        let storedMemoRepositoryDeleteMemoFuncDidExecute = XCTestExpectation()
        storedMemoRepository.stubbedDeleteMemo = { _ in
            storedMemoRepositoryDeleteMemoFuncDidExecute.fulfill()
        }

        let liveActivityMemoRepositoryDeleteMemoFuncDidExecute = XCTestExpectation().then {
            $0.isInverted = true
        }
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
