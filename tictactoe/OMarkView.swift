import SwiftUI

struct OMarkView: View {
    @State private var trimEnd: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let inset = GameConstants.markInset
            let rect = CGRect(
                x: inset,
                y: inset,
                width: geo.size.width - inset * 2,
                height: geo.size.height - inset * 2
            )

            Path { path in
                path.addEllipse(in: rect)
            }
            .trim(from: 0, to: trimEnd)
            .stroke(
                GameConstants.oGradient,
                style: StrokeStyle(lineWidth: GameConstants.markStrokeWidth, lineCap: .round)
            )
            .shadow(color: GameConstants.oGlowColor.opacity(0.5), radius: 6)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(.easeOut(duration: GameConstants.markDrawDuration)) {
                trimEnd = 1
            }
        }
    }
}
