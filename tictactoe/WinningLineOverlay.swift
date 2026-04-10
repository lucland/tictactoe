import SwiftUI

struct WinningLineOverlay: View {
    let cells: [Int]
    let boardSize: CGFloat
    let spacing: CGFloat
    let gridSize: Int

    @State private var trimEnd: CGFloat = 0

    private var cellSize: CGFloat {
        (boardSize - CGFloat(gridSize - 1) * spacing) / CGFloat(gridSize)
    }

    private func cellCenter(_ index: Int) -> CGPoint {
        let row = index / gridSize
        let col = index % gridSize
        return CGPoint(
            x: CGFloat(col) * (cellSize + spacing) + cellSize / 2,
            y: CGFloat(row) * (cellSize + spacing) + cellSize / 2
        )
    }

    var body: some View {
        if let first = cells.first, let last = cells.last {
            let start = cellCenter(first)
            let end = cellCenter(last)

            Path { path in
                path.move(to: start)
                path.addLine(to: end)
            }
            .trim(from: 0, to: trimEnd)
            .stroke(
                GameConstants.winGradient,
                style: StrokeStyle(lineWidth: GameConstants.winLineWidth, lineCap: .round)
            )
            .shadow(color: .yellow.opacity(0.6), radius: 10)
            .shadow(color: .white.opacity(0.3), radius: 4)
            .onAppear {
                withAnimation(.easeOut(duration: GameConstants.winLineDrawDuration)) {
                    trimEnd = 1
                }
            }
        }
    }
}
