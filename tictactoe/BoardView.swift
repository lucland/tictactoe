import SwiftUI

struct BoardView: View {
    let viewModel: GameViewModel

    private let columns: [GridItem]

    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        self.columns = Array(
            repeating: GridItem(.flexible(), spacing: GameConstants.cellSpacing),
            count: GameConstants.gridSize
        )
    }

    var body: some View {
        GeometryReader { geo in
            let boardSize = min(geo.size.width, geo.size.height)

            ZStack {
                LazyVGrid(columns: columns, spacing: GameConstants.cellSpacing) {
                    ForEach(0..<GameConstants.totalCells, id: \.self) { index in
                        CellView(
                            state: viewModel.board.cells[index],
                            isWinningCell: viewModel.winningCells?.contains(index) ?? false
                        ) {
                            viewModel.playerTap(at: index)
                        }
                    }
                }
                .frame(width: boardSize, height: boardSize)

                if let winCells = viewModel.winningCells {
                    WinningLineOverlay(
                        cells: winCells,
                        boardSize: boardSize,
                        spacing: GameConstants.cellSpacing,
                        gridSize: GameConstants.gridSize
                    )
                    .frame(width: boardSize, height: boardSize)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(.horizontal, GameConstants.boardPadding)
        .allowsHitTesting(viewModel.isPlayerTurn)
    }
}
