import UIKit

final class HapticManager {
    static let shared = HapticManager()

    private init() {}

    func lightTap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    func mediumTap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    func heavyTap() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func failure() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    func selectionChanged() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
