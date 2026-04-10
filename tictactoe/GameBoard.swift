import Foundation

// MARK: - Player

enum Player: Equatable {
    case x, o

    var opponent: Player {
        self == .x ? .o : .x
    }
}

// MARK: - Cell State

enum CellState: Equatable {
    case empty, x, o

    var player: Player? {
        switch self {
        case .empty: nil
        case .x: .x
        case .o: .o
        }
    }
}

// MARK: - Game Result

enum GameResult: Equatable {
    case playing
    case won(Player, [Int])
    case draw
}

// MARK: - Game Board (NxN Scalable)

struct GameBoard: Equatable {
    let size: Int
    private(set) var cells: [CellState]

    init(size: Int = GameConstants.gridSize) {
        self.size = size
        self.cells = Array(repeating: .empty, count: size * size)
    }

    var availableMoves: [Int] {
        cells.indices.filter { cells[$0] == .empty }
    }

    var isFull: Bool {
        !cells.contains(.empty)
    }

    mutating func place(_ player: Player, at index: Int) {
        guard index >= 0, index < cells.count, cells[index] == .empty else { return }
        cells[index] = player == .x ? .x : .o
    }

    func checkResult() -> GameResult {
        for line in winningLines() {
            let first = cells[line[0]]
            if first != .empty, line.allSatisfy({ cells[$0] == first }),
               let player = first.player {
                return .won(player, line)
            }
        }
        return isFull ? .draw : .playing
    }

    /// All possible winning lines for an NxN board: rows, columns, and both diagonals.
    func winningLines() -> [[Int]] {
        var lines: [[Int]] = []

        // Rows
        for row in 0..<size {
            lines.append((0..<size).map { row * size + $0 })
        }

        // Columns
        for col in 0..<size {
            lines.append((0..<size).map { $0 * size + col })
        }

        // Main diagonal (top-left to bottom-right)
        lines.append((0..<size).map { $0 * size + $0 })

        // Anti-diagonal (top-right to bottom-left)
        lines.append((0..<size).map { $0 * size + (size - 1 - $0) })

        return lines
    }
}
