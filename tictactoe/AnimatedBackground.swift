import SwiftUI

struct AnimatedBackground: View {
    @State private var breathing = false

    var body: some View {
        ZStack {
            Color(red: 0.03, green: 0.01, blue: 0.10)

            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    Color(red: 0.08, green: 0.03, blue: 0.20),
                    Color(red: 0.12, green: 0.05, blue: 0.28),
                    Color(red: 0.05, green: 0.10, blue: 0.25),

                    Color(red: 0.04, green: 0.12, blue: 0.28),
                    Color(red: 0.10, green: 0.04, blue: 0.18),
                    Color(red: 0.06, green: 0.08, blue: 0.32),

                    Color(red: 0.05, green: 0.06, blue: 0.22),
                    Color(red: 0.09, green: 0.03, blue: 0.18),
                    Color(red: 0.04, green: 0.10, blue: 0.26)
                ]
            )
            .opacity(breathing ? 0.88 : 1.0)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                breathing = true
            }
        }
    }
}
