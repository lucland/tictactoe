import SwiftUI

struct GameView: View {
    let viewModel: GameViewModel
    let onExit: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            header
            ScoreBarView(viewModel: viewModel)

            Spacer()

            turnIndicator
            BoardView(viewModel: viewModel)

            Spacer()
            Spacer()
        }
        .overlay {
            if viewModel.showingGameOver {
                GameOverView(viewModel: viewModel)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.spring(duration: 0.4), value: viewModel.showingGameOver)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button(action: onExit) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text(viewModel.difficulty.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.5))

            Spacer()

            // Balance the back button
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 12)
    }

    // MARK: - Turn Indicator

    private var turnIndicator: some View {
        Group {
            if viewModel.gameResult == .playing {
                HStack(spacing: 8) {
                    if viewModel.isAIThinking {
                        ProgressView()
                            .tint(.white.opacity(0.6))
                            .scaleEffect(0.8)
                        Text("CPU is thinking…")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.5))
                    } else {
                        Circle()
                            .fill(GameConstants.xGlowColor)
                            .frame(width: 8, height: 8)
                        Text("Your turn")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.isAIThinking)
            } else {
                Color.clear.frame(height: 20)
            }
        }
    }
}
