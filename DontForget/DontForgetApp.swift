//
//  DontForgetApp.swift
//  DontForget
//
//  Created by Gyuni on 2023/07/09.
//

import SwiftUI

@main
struct DontForgetApp: App {
    private let liveActivityMemoRepository = LiveActivityMemoRepository()
    private let storedMemoRepository = StoredMemoRepository()
    private let uiPasteBoardService = UIPasteBoardService()
    private let notificationHapticFeedbackService = NotificationHapticFeedbackService()
    private let idGenerator = DateBasedIDGenerator()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                let liveMemoService = LiveMemoService(
                    liveActivityMemoRepository: liveActivityMemoRepository,
                    storedMemoRepository: storedMemoRepository,
                    idGenerator: idGenerator
                )

                let archivedMemoService = ArchivedMemoService(
                    liveActivityMemoRepository: liveActivityMemoRepository,
                    storedMemoRepository: storedMemoRepository
                )

                let viewModel = MainViewModel(
                    liveMemoCreateService: liveMemoService,
                    liveMemoReadService: liveMemoService,
                    liveMemoDeleteService: liveMemoService,
                    archivedMemoReadService: archivedMemoService,
                    archivedMemoDeleteService: archivedMemoService,
                    clipboardService: uiPasteBoardService,
                    hapticFeedbackService: notificationHapticFeedbackService
                )

                MainView(viewModel: viewModel)
            }
        }
    }
}
