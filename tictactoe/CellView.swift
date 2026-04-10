import SwiftUI

struct CellView: View {
    let state: CellState
    let isWinningCell: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: GameConstants.cellCornerRadius)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: GameConstants.cellCornerRadius)
                    .stroke(borderGradient, lineWidth: isWinningCell ? 1.5 : 0.8)

                switch state {
                case .empty:
                    EmptyView()
                case .x:
                    XMarkView()
                case .o:
                    OMarkView()
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .buttonStyle(CellButtonStyle())
    }

    private var borderGradient: LinearGradient {
        if isWinningCell {
            return LinearGradient(
                colors: [.yellow.opacity(0.6), .white.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        return LinearGradient(
            colors: [.white.opacity(0.2), .white.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Cell Button Style

private struct CellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
