import SwiftUI

struct HomeView: View {
    let viewModel: GameViewModel
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 12) {
                Text("Tic Tac Toe")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("Choose your challenge")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.5))
            }

            VStack(spacing: 14) {
                ForEach(Difficulty.allCases, id: \.self) { level in
                    DifficultyCard(
                        difficulty: level,
                        isSelected: viewModel.difficulty == level
                    ) {
                        viewModel.selectDifficulty(level)
                    }
                }
            }
            .padding(.horizontal, 32)

            Button(action: onStart) {
                Text("Play")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(PlayButtonStyle())
            .padding(.horizontal, 48)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Difficulty Card

private struct DifficultyCard: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            HapticManager.shared.selectionChanged()
            onTap()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: difficulty.iconName)
                    .font(.title3)
                    .foregroundStyle(iconColor)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(difficulty.rawValue)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Text(difficulty.subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
                    .opacity(isSelected ? 1 : 0.6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isSelected
                            ? LinearGradient(
                                colors: [.white.opacity(0.4), .white.opacity(0.1)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [.white.opacity(0.15), .white.opacity(0.03)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }

    private var iconColor: Color {
        switch difficulty {
        case .easy: .green
        case .medium: .orange
        case .hard: .red
        }
    }
}

// MARK: - Play Button Style

private struct PlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 16)
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
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(
                color: Color(red: 0.4, green: 0.2, blue: 0.8).opacity(0.4),
                radius: 16, y: 4
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
