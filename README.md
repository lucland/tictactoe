# Tic Tac Toe

A polished single-player Tic Tac Toe game built with native Swift and SwiftUI, targeting a 5-star App Store experience.

## Requirements

- **Xcode 26.0+** (with iOS 26 SDK)
- **iOS 26.0+** device or simulator
- macOS Tahoe or later

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/lucland/tictactoe.git
   cd tictactoe
   ```
2. Open `tictactoe.xcodeproj` in Xcode
3. Select your target device or simulator
4. Press **Cmd + R** to build and run

No dependencies, no CocoaPods, no SPM packages — just open and run.

## Gameplay

- **You** play as **X** (cyan), **CPU** plays as **O** (pink)
- Three difficulty levels:
  - **Easy** — relaxed and casual; blocks obvious wins but mostly plays random moves
  - **Medium** — depth-limited minimax with light randomness; a fair challenge without feeling impossible
  - **Hard** — full minimax with alpha-beta pruning; unbeatable
- **Loser starts** the next game; draws alternate the starter
- A rating prompt (simulation) appears after your first win

## Features

- **Liquid glass UI** — dark mesh gradient background with frosted-glass cards using `ultraThinMaterial`
- **Custom-drawn marks** — X and O rendered with `Path`, gradient strokes, glow effects, and draw-on `trim` animation
- **Sound effects** — procedurally synthesized tones (no audio files); ascending chime on win, descending interval on loss, pop on each move
- **Haptic feedback** — light tap on player move, medium tap on CPU move, success/failure notification on game end, selection feedback on difficulty change
- **Winning line animation** — animated line drawn across the winning cells with glow
- **Polished game-over overlay** — custom glass card (not a system alert) with score summary, rating prompt, and spring entrance animation
- **Smart game flow** — board input is fully disabled during CPU turn (no race conditions), moves are queued via async/await

## Project Structure

```
tictactoe/
├── tictactoeApp.swift         — App entry point (no SwiftData, no unnecessary frameworks)
├── ContentView.swift          — Root navigation between Home and Game screens
│
│── GameConstants.swift        — All named constants: grid size, timing, layout, colors
│── GameBoard.swift            — NxN-scalable board model with generic win detection
│── AIEngine.swift             — Minimax + alpha-beta pruning, 3 calibrated difficulty tiers
│── GameViewModel.swift        — Game orchestration: turns, scores, AI trigger, rating logic
│
│── HomeView.swift             — Difficulty selection screen
│── GameView.swift             — Main game screen (header, score bar, board, turn indicator)
│── BoardView.swift            — LazyVGrid board with winning-line overlay
│── CellView.swift             — Individual glass cell with button interaction
│── GameOverView.swift         — Custom game-over overlay with rating prompt
│── ScoreBarView.swift         — Live score display in glass card
│
│── XMarkView.swift            — Custom Path-drawn X with gradient stroke + glow
│── OMarkView.swift            — Custom Path-drawn O with gradient stroke + glow
│── GlassCard.swift            — Reusable glassmorphism container component
│── AnimatedBackground.swift   — Mesh gradient background with subtle breathing animation
│── WinningLineOverlay.swift   — Animated winning line across victorious cells
│
│── SoundManager.swift         — Procedural WAV tone synthesis (no audio file dependencies)
│── HapticManager.swift        — Centralized haptic feedback (light, medium, success, failure)
│
├── Assets.xcassets/
├── Info.plist
└── tictactoe.entitlements
```

## Design Decisions

Every decision below directly addresses specific feedback from prior submissions:

| Prior Feedback | How It's Addressed |
|---|---|
| System alerts for game over | Custom `GameOverView` overlay with glass card and spring animation |
| Who starts next game unclear | Loser starts next; draws alternate the starting player |
| AI was 100% deterministic | Randomness at every difficulty; equal-scoring moves are shuffled |
| AI used a `while()` loop | Minimax iterates over `board.availableMoves` directly — no polling |
| Generic X/O icons | Custom `Path`-drawn marks with gradient strokes, rounded caps, and glow |
| Animations without purpose | Only purposeful animations: draw-on for marks, winning line, overlay entrance |
| Magic numbers everywhere | Every value lives in `GameConstants` — zero hardcoded literals in logic |
| Win checks hardcoded for 3x3 | `winningLines()` generates lines from `size` — fully NxN scalable |
| Difficulty levels poorly calibrated | Easy: 35% random + blocking; Medium: depth-4 minimax + 12% random; Hard: full minimax |
| Unnecessary features added | No translations, no settings toggles — focused entirely on core experience |
| Player could tap during CPU turn | Board uses `.allowsHitTesting(viewModel.isPlayerTurn)` — input fully disabled during AI turn |

## AI Implementation

The CPU opponent uses **minimax with alpha-beta pruning**:

- **Easy**: 35% pure random moves; otherwise blocks immediate wins/losses. Feels casual.
- **Medium**: Minimax with depth limit of 4, plus 12% chance of a random move. Fair but beatable with strategy.
- **Hard**: Full-depth minimax with alpha-beta pruning. Mathematically unbeatable — best outcome is a draw.

All difficulties pick randomly among equally-scored moves, ensuring no two games feel identical.

A **heuristic evaluation function** scores partially-filled lines for the depth-limited search, weighting AI and human threats quadratically.

## Running Tests

```bash
xcodebuild test \
  -project tictactoe.xcodeproj \
  -scheme tictactoe \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Test coverage includes:
- Board operations (place, bounds checking, occupied cell rejection)
- Win detection for rows, columns, main diagonal, and anti-diagonal
- Draw detection
- NxN scalability (4x4, 5x5 boards; winning line count verification)
- AI move validity across all difficulty levels
- AI blocking behavior (must block immediate opponent win)
- AI winning behavior (must take immediate win over blocking)
- AI nil return on full board
