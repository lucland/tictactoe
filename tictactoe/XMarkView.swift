import SwiftUI

struct XMarkView: View {
    @State private var trimEnd: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let inset = GameConstants.markInset
            let size = geo.size

            ZStack {
                // Top-left → bottom-right
                Path { path in
                    path.move(to: CGPoint(x: inset, y: inset))
                    path.addLine(to: CGPoint(x: size.width - inset, y: size.height - inset))
                }
                .trim(from: 0, to: trimEnd)
                .stroke(
                    GameConstants.xGradient,
                    style: StrokeStyle(lineWidth: GameConstants.markStrokeWidth, lineCap: .round)
                )
                .shadow(color: GameConstants.xGlowColor.opacity(0.5), radius: 6)

                // Top-right → bottom-left
                Path { path in
                    path.move(to: CGPoint(x: size.width - inset, y: inset))
                    path.addLine(to: CGPoint(x: inset, y: size.height - inset))
                }
                .trim(from: 0, to: trimEnd)
                .stroke(
                    GameConstants.xGradient,
                    style: StrokeStyle(lineWidth: GameConstants.markStrokeWidth, lineCap: .round)
                )
                .shadow(color: GameConstants.xGlowColor.opacity(0.5), radius: 6)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(.easeOut(duration: GameConstants.markDrawDuration)) {
                trimEnd = 1
            }
        }
    }
}
