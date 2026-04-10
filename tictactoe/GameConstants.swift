import SwiftUI

enum GameConstants {
    static let gridSize = 3
    static let totalCells = gridSize * gridSize

    // MARK: - Timing

    static let markDrawDuration: Double = 0.35
    static let aiMoveDelay: Duration = .milliseconds(450)
    static let gameOverPresentDelay: Duration = .milliseconds(700)
    static let winLineDrawDuration: Double = 0.4

    // MARK: - Layout

    static let boardPadding: CGFloat = 24
    static let cellSpacing: CGFloat = 10
    static let cellCornerRadius: CGFloat = 16
    static let markStrokeWidth: CGFloat = 7
    static let markInset: CGFloat = 22
    static let winLineWidth: CGFloat = 5

    // MARK: - Rating

    static let winsBeforeRatingPrompt = 1

    // MARK: - Colors

    static let xGradient = LinearGradient(
        colors: [Color(red: 0.0, green: 0.82, blue: 1.0), Color(red: 0.23, green: 0.48, blue: 0.84)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let oGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.42, blue: 0.62), Color(red: 0.77, green: 0.44, blue: 0.93)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let xGlowColor = Color(red: 0.0, green: 0.82, blue: 1.0)
    static let oGlowColor = Color(red: 1.0, green: 0.42, blue: 0.62)

    static let winGradient = LinearGradient(
        colors: [.white, Color(red: 1.0, green: 0.84, blue: 0.0)],
        startPoint: .leading,
        endPoint: .trailing
    )
}
