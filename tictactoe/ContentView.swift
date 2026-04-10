import SwiftUI

struct ContentView: View {
    @State private var viewModel = GameViewModel()
    @State private var isPlaying = false

    var body: some View {
        ZStack {
            AnimatedBackground()

            if isPlaying {
                GameView(viewModel: viewModel) {
                    withAnimation(.smooth(duration: 0.4)) {
                        isPlaying = false
                    }
                    viewModel.resetScores()
                    viewModel.startNewGame()
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
            } else {
                HomeView(viewModel: viewModel) {
                    withAnimation(.smooth(duration: 0.4)) {
                        isPlaying = true
                    }
                    viewModel.startNewGame()
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .animation(.smooth(duration: 0.4), value: isPlaying)
    }
}
