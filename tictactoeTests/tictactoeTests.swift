import Testing
@testable import tictactoe

@MainActor
struct GameBoardTests {

    // MARK: - Board Basics

    @Test func emptyBoardHasAllMovesAvailable() {
        let board = GameBoard()
        #expect(board.availableMoves.count == GameConstants.totalCells)
    }

    @Test func placeReducesAvailableMoves() {
        var board = GameBoard()
        board.place(.x, at: 0)
        #expect(board.availableMoves.count == GameConstants.totalCells - 1)
        #expect(board.cells[0] == .x)
    }

    @Test func cannotPlaceOnOccupiedCell() {
        var board = GameBoard()
        board.place(.x, at: 0)
        board.place(.o, at: 0)
        #expect(board.cells[0] == .x)
    }

    @Test func cannotPlaceOutOfBounds() {
        var board = GameBoard()
        board.place(.x, at: -1)
        board.place(.x, at: GameConstants.totalCells)
        #expect(board.availableMoves.count == GameConstants.totalCells)
    }

    // MARK: - Win Detection

    @Test func detectsRowWin() {
        var board = GameBoard()
        for col in 0..<GameConstants.gridSize {
            board.place(.x, at: col)
        }

        if case .won(let player, let cells) = board.checkResult() {
            #expect(player == .x)
            #expect(cells == Array(0..<GameConstants.gridSize))
        } else {
            Issue.record("Expected row win")
        }
    }

    @Test func detectsColumnWin() {
        var board = GameBoard()
        for row in 0..<GameConstants.gridSize {
            board.place(.o, at: row * GameConstants.gridSize)
        }

        if case .won(let player, _) = board.checkResult() {
            #expect(player == .o)
        } else {
            Issue.record("Expected column win")
        }
    }

    @Test func detectsMainDiagonalWin() {
        var board = GameBoard()
        for i in 0..<GameConstants.gridSize {
            board.place(.x, at: i * GameConstants.gridSize + i)
        }

        if case .won(let player, _) = board.checkResult() {
            #expect(player == .x)
        } else {
            Issue.record("Expected diagonal win")
        }
    }

    @Test func detectsAntiDiagonalWin() {
        var board = GameBoard()
        for i in 0..<GameConstants.gridSize {
            board.place(.o, at: i * GameConstants.gridSize + (GameConstants.gridSize - 1 - i))
        }

        if case .won(let player, _) = board.checkResult() {
            #expect(player == .o)
        } else {
            Issue.record("Expected anti-diagonal win")
        }
    }

    @Test func detectsDraw() {
        var board = GameBoard()
        // X O X
        // X X O
        // O X O
        let moves: [(Player, Int)] = [
            (.x, 0), (.o, 1), (.x, 2),
            (.x, 3), (.x, 4), (.o, 5),
            (.o, 6), (.x, 7), (.o, 8),
        ]
        for (player, index) in moves {
            board.place(player, at: index)
        }
        #expect(board.checkResult() == .draw)
    }

    @Test func gameInProgress() {
        var board = GameBoard()
        board.place(.x, at: 0)
        #expect(board.checkResult() == .playing)
    }

    // MARK: - NxN Scalability

    @Test func worksWithCustomBoardSize() {
        var board = GameBoard(size: 4)
        #expect(board.availableMoves.count == 16)

        for col in 0..<4 {
            board.place(.x, at: col)
        }

        if case .won(let player, let cells) = board.checkResult() {
            #expect(player == .x)
            #expect(cells == [0, 1, 2, 3])
        } else {
            Issue.record("Expected 4x4 row win")
        }
    }

    @Test func winningLinesScaleWithGridSize() {
        let board3 = GameBoard(size: 3)
        // 3 rows + 3 cols + 2 diags = 8
        #expect(board3.winningLines().count == 8)

        let board4 = GameBoard(size: 4)
        // 4 rows + 4 cols + 2 diags = 10
        #expect(board4.winningLines().count == 10)

        let board5 = GameBoard(size: 5)
        // 5 rows + 5 cols + 2 diags = 12
        #expect(board5.winningLines().count == 12)
    }
}

@MainActor
struct AIEngineTests {

    @Test func aiReturnsValidMove() {
        let board = GameBoard()
        let engine = AIEngine(difficulty: .hard)
        let move = engine.bestMove(for: board)
        #expect(move != nil)
        #expect(board.availableMoves.contains(move!))
    }

    @Test func aiBlocksImmediateWin() {
        var board = GameBoard()
        // X X _
        // O _ _
        // _ _ _
        board.place(.x, at: 0)
        board.place(.x, at: 1)
        board.place(.o, at: 3)

        let engine = AIEngine(difficulty: .hard)
        let move = engine.bestMove(for: board)
        #expect(move == 2)
    }

    @Test func aiTakesWinningMove() {
        var board = GameBoard()
        // O O _
        // X X _
        // _ _ _
        board.place(.o, at: 0)
        board.place(.o, at: 1)
        board.place(.x, at: 3)
        board.place(.x, at: 4)

        let engine = AIEngine(difficulty: .hard)
        let move = engine.bestMove(for: board)
        #expect(move == 2)
    }

    @Test func aiReturnsNilOnFullBoard() {
        var board = GameBoard()
        let moves: [(Player, Int)] = [
            (.x, 0), (.o, 1), (.x, 2),
            (.x, 3), (.x, 4), (.o, 5),
            (.o, 6), (.x, 7), (.o, 8),
        ]
        for (player, index) in moves {
            board.place(player, at: index)
        }

        let engine = AIEngine(difficulty: .hard)
        #expect(engine.bestMove(for: board) == nil)
    }

    @Test func easyDifficultyReturnsValidMoves() {
        let board = GameBoard()
        let engine = AIEngine(difficulty: .easy)

        for _ in 0..<20 {
            let move = engine.bestMove(for: board)
            #expect(move != nil)
            #expect(board.availableMoves.contains(move!))
        }
    }

    @Test func mediumDifficultyReturnsValidMoves() {
        let board = GameBoard()
        let engine = AIEngine(difficulty: .medium)

        for _ in 0..<20 {
            let move = engine.bestMove(for: board)
            #expect(move != nil)
            #expect(board.availableMoves.contains(move!))
        }
    }
}
