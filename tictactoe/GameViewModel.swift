import SwiftUI

@Observable
final class GameViewModel {

    // MARK: - Game State

    var board = GameBoard()
    var currentPlayer: Player = .x
    var gameResult: GameResult = .playing
    var difficulty: Difficulty = .medium
    var showingGameOver = false
    var isAIThinking = false
    var moveSequence: [Int] = []

    // MARK: - Scores

    var playerWins = 0
    var aiWins = 0
    var draws = 0

    // MARK: - Review Trigger

    var shouldTriggerReview = false

    // MARK: - Private

    private var nextStarter: Player = .x
    private var hasPromptedForRating = false

    // MARK: - Computed Properties

    var isPlayerTurn: Bool {
        currentPlayer == .x && gameResult == .playing && !isAIThinking
    }

    var winningCells: [Int]? {
        if case .won(_, let cells) = gameResult { return cells }
        return nil
    }

    // MARK: - Actions

    func startNewGame() {
        board = GameBoard()
        currentPlayer = nextStarter
        gameResult = .playing
        showingGameOver = false
        isAIThinking = false
        moveSequence = []

        if nextStarter == .o {
            triggerAIMove()
        }
    }

    func playerTap(at index: Int) {
        guard isPlayerTurn, board.cells[index] == .empty else { return }

        placeMove(at: index, for: .x)

        if gameResult == .playing {
            triggerAIMove()
        }
    }

    func playAgain() {
        shouldTriggerReview = false
        startNewGame()
    }

    func selectDifficulty(_ newDifficulty: Difficulty) {
        difficulty = newDifficulty
        resetScores()
    }

    func resetScores() {
        playerWins = 0
        aiWins = 0
        draws = 0
        nextStarter = .x
        hasPromptedForRating = false
    }

    // MARK: - Private Methods

    private func placeMove(at index: Int, for player: Player) {
        board.place(player, at: index)
        moveSequence.append(index)
        currentPlayer = player.opponent

        if player == .x {
            HapticManager.shared.lightTap()
        } else {
            HapticManager.shared.mediumTap()
        }
        SoundManager.shared.playPlace()

        let result = board.checkResult()
        if result != .playing {
            endGame(with: result)
        }
    }

    private func triggerAIMove() {
        isAIThinking = true

        Task {
            try? await Task.sleep(for: GameConstants.aiMoveDelay)
            guard gameResult == .playing else {
                isAIThinking = false
                return
            }

            let engine = AIEngine(difficulty: difficulty)
            if let move = engine.bestMove(for: board) {
                placeMove(at: move, for: .o)
            }
            isAIThinking = false
        }
    }

    private func endGame(with result: GameResult) {
        gameResult = result

        switch result {
        case .won(let player, _):
            if player == .x {
                playerWins += 1
                nextStarter = .o // Loser starts next
                if !hasPromptedForRating && playerWins >= GameConstants.winsBeforeRatingPrompt {
                    hasPromptedForRating = true
                    shouldTriggerReview = true
                }
                HapticManager.shared.success()
                SoundManager.shared.playWin()
            } else {
                aiWins += 1
                nextStarter = .x // Loser starts next
                HapticManager.shared.failure()
                SoundManager.shared.playLose()
            }
        case .draw:
            draws += 1
            nextStarter = nextStarter.opponent // Alternate on draw
            HapticManager.shared.lightTap()
            SoundManager.shared.playDraw()
        case .playing:
            break
        }

        Task {
            try? await Task.sleep(for: GameConstants.gameOverPresentDelay)
            showingGameOver = true
        }
    }
}
