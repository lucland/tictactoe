import SwiftUI

struct ScoreBarView: View {
    let viewModel: GameViewModel

    var body: some View {
        GlassCard(cornerRadius: 16) {
            HStack(spacing: 0) {
                scoreColumn(label: "You", score: viewModel.playerWins, color: GameConstants.xGlowColor)

                Divider()
                    .frame(height: 32)
                    .overlay(Color.white.opacity(0.15))

                scoreColumn(label: "Draw", score: viewModel.draws, color: .white.opacity(0.6))

                Divider()
                    .frame(height: 32)
                    .overlay(Color.white.opacity(0.15))

                scoreColumn(label: "CPU", score: viewModel.aiWins, color: GameConstants.oGlowColor)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
        }
        .padding(.horizontal, GameConstants.boardPadding)
    }

    private func scoreColumn(label: String, score: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(color.opacity(0.8))

            Text("\(score)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
    }
}
