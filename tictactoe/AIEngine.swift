import Foundation

// MARK: - Difficulty

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var subtitle: String {
        switch self {
        case .easy: "Relaxed & casual"
        case .medium: "A fair challenge"
        case .hard: "Unbeatable"
        }
    }

    var iconName: String {
        switch self {
        case .easy: "leaf.fill"
        case .medium: "flame.fill"
        case .hard: "bolt.fill"
        }
    }
}

// MARK: - AI Engine (Minimax with Alpha-Beta Pruning)

struct AIEngine {
    let difficulty: Difficulty

    private static let aiMark: Player = .o
    private static let humanMark: Player = .x

    /// Returns the best move index for the AI, or nil if the board is full.
    func bestMove(for board: GameBoard) -> Int? {
        let available = board.availableMoves
        guard !available.isEmpty else { return nil }

        switch difficulty {
        case .easy: return easyMove(board: board, available: available)
        case .medium: return mediumMove(board: board, available: available)
        case .hard: return hardMove(board: board, available: available)
        }
    }

    // MARK: - Easy: blocks wins, otherwise random

    private func easyMove(board: GameBoard, available: [Int]) -> Int {
        // 35% pure random for a casual feel
        if Double.random(in: 0...1) < 0.35 {
            return available.randomElement()!
        }

        // Take an immediate win
        if let win = findImmediateWin(board: board, player: Self.aiMark) {
            return win
        }

        // Block an immediate loss
        if let block = findImmediateWin(board: board, player: Self.humanMark) {
            return block
        }

        return available.randomElement()!
    }

    // MARK: - Medium: shallow minimax with light randomness

    private func mediumMove(board: GameBoard, available: [Int]) -> Int {
        // 12% pure random keeps it unpredictable
        if Double.random(in: 0...1) < 0.12 {
            return available.randomElement()!
        }

        let maxDepth = 4
        var bestScore = Int.min
        var bestMoves: [Int] = []

        for move in available {
            var next = board
            next.place(Self.aiMark, at: move)
            let score = minimax(
                board: next, depth: maxDepth - 1,
                isMaximizing: false, alpha: Int.min, beta: Int.max
            )
            if score > bestScore {
                bestScore = score
                bestMoves = [move]
            } else if score == bestScore {
                bestMoves.append(move)
            }
        }

        return bestMoves.randomElement() ?? available.randomElement()!
    }

    // MARK: - Hard: full minimax (unbeatable)

    private func hardMove(board: GameBoard, available: [Int]) -> Int {
        var bestScore = Int.min
        var bestMoves: [Int] = []

        for move in available {
            var next = board
            next.place(Self.aiMark, at: move)
            let score = minimax(
                board: next, depth: available.count - 1,
                isMaximizing: false, alpha: Int.min, beta: Int.max
            )
            if score > bestScore {
                bestScore = score
                bestMoves = [move]
            } else if score == bestScore {
                bestMoves.append(move)
            }
        }

        // Random among equally optimal moves for variety
        return bestMoves.randomElement() ?? available.randomElement()!
    }

    // MARK: - Minimax with Alpha-Beta Pruning

    private func minimax(
        board: GameBoard, depth: Int,
        isMaximizing: Bool, alpha: Int, beta: Int
    ) -> Int {
        let result = board.checkResult()

        switch result {
        case .won(let player, _):
            // Prefer faster wins / slower losses
            return player == Self.aiMark ? 100 + depth : -100 - depth
        case .draw:
            return 0
        case .playing:
            if depth == 0 { return evaluateBoard(board) }
        }

        var alpha = alpha
        var beta = beta

        if isMaximizing {
            var best = Int.min
            for move in board.availableMoves {
                var next = board
                next.place(Self.aiMark, at: move)
                best = max(best, minimax(
                    board: next, depth: depth - 1,
                    isMaximizing: false, alpha: alpha, beta: beta
                ))
                alpha = max(alpha, best)
                if beta <= alpha { break }
            }
            return best
        } else {
            var best = Int.max
            for move in board.availableMoves {
                var next = board
                next.place(Self.humanMark, at: move)
                best = min(best, minimax(
                    board: next, depth: depth - 1,
                    isMaximizing: true, alpha: alpha, beta: beta
                ))
                beta = min(beta, best)
                if beta <= alpha { break }
            }
            return best
        }
    }

    // MARK: - Heuristic (for depth-limited search)

    private func evaluateBoard(_ board: GameBoard) -> Int {
        var score = 0
        for line in board.winningLines() {
            let aiCount = line.filter { board.cells[$0] == .o }.count
            let humanCount = line.filter { board.cells[$0] == .x }.count

            if humanCount == 0 && aiCount > 0 {
                score += aiCount * aiCount
            }
            if aiCount == 0 && humanCount > 0 {
                score -= humanCount * humanCount
            }
        }
        return score
    }

    // MARK: - Helpers

    private func findImmediateWin(board: GameBoard, player: Player) -> Int? {
        for move in board.availableMoves {
            var test = board
            test.place(player, at: move)
            if case .won = test.checkResult() {
                return move
            }
        }
        return nil
    }
}
