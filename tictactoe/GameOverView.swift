import SwiftUI

struct GameOverView: View {
    let viewModel: GameViewModel

    @State private var appeared = false
    @State private var selectedStars = 0

    private var showRatingPrompt: Bool {
        viewModel.shouldTriggerReview && isPlayerWin
    }

    private var isPlayerWin: Bool {
        if case .won(.x, _) = viewModel.gameResult { return true }
        return false
    }

    var body: some View {
        ZStack {
            Color.black.opacity(appeared ? 0.5 : 0)
                .ignoresSafeArea()
                .onTapGesture {}

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(titleColor)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.5))
                }

                HStack(spacing: 32) {
                    miniScore(label: "You", value: viewModel.playerWins, color: GameConstants.xGlowColor)
                    miniScore(label: "Draw", value: viewModel.draws, color: .white.opacity(0.5))
                    miniScore(label: "CPU", value: viewModel.aiWins, color: GameConstants.oGlowColor)
                }

                if showRatingPrompt {
                    ratingSection
                }

                Button {
                    viewModel.playAgain()
                } label: {
                    Text("Play Again")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.3, green: 0.2, blue: 0.8),
                                            Color(red: 0.5, green: 0.2, blue: 0.7),
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.25), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 20, y: 8)
            .padding(.horizontal, 40)
            .scaleEffect(appeared ? 1 : 0.9)
            .opacity(appeared ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                appeared = true
            }
        }
    }

    // MARK: - Rating Section

    private var ratingSection: some View {
        VStack(spacing: 10) {
            Divider()
                .overlay(Color.white.opacity(0.1))

            Text("Enjoying Tic Tac Toe?")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.8))

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= selectedStars ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundStyle(star <= selectedStars ? .yellow : .white.opacity(0.3))
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.15)) {
                                selectedStars = star
                            }
                            HapticManager.shared.selectionChanged()
                        }
                }
            }
            .padding(.vertical, 4)

            Text("App Store rating simulation — not in production")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.3))
        }
    }

    // MARK: - Content Helpers

    private var title: String {
        switch viewModel.gameResult {
        case .won(.x, _): "You Win!"
        case .won(.o, _): "CPU Wins"
        case .draw: "It's a Draw"
        case .playing: ""
        }
    }

    private var titleColor: Color {
        switch viewModel.gameResult {
        case .won(.x, _): GameConstants.xGlowColor
        case .won(.o, _): GameConstants.oGlowColor
        case .draw: .white.opacity(0.7)
        case .playing: .white
        }
    }

    private var subtitle: String {
        switch viewModel.gameResult {
        case .won(.x, _): "Great move!"
        case .won(.o, _): "Better luck next time"
        case .draw: "Well played by both sides"
        case .playing: ""
        }
    }

    private func miniScore(label: String, value: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.4))
        }
    }
}
