//
//  NotificationHapticFeedbackService.swift
//  DontForget
//
//  Created by Gyuni on 4/14/24.
//

import UIKit

final class NotificationHapticFeedbackService: HapticFeedbackService {
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()

    init() {
        notificationFeedbackGenerator.prepare()
    }

    func generateSuccessFeedback() {
        notificationFeedbackGenerator.notificationOccurred(.success)
    }
}
