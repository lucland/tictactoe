import AVFoundation

final class SoundManager {
    static let shared = SoundManager()

    private var players: [AVAudioPlayer] = []
    private let sampleRate: Double = 44100

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
    }

    // MARK: - Game Sounds

    func playPlace() {
        playTone(frequency: 880, duration: 0.06, amplitude: 0.25)
    }

    func playWin() {
        Task {
            playTone(frequency: 523.25, duration: 0.14, amplitude: 0.35) // C5
            try? await Task.sleep(for: .milliseconds(110))
            playTone(frequency: 659.25, duration: 0.14, amplitude: 0.35) // E5
            try? await Task.sleep(for: .milliseconds(110))
            playTone(frequency: 783.99, duration: 0.28, amplitude: 0.45) // G5
        }
    }

    func playLose() {
        Task {
            playTone(frequency: 293.66, duration: 0.18, amplitude: 0.25) // D4
            try? await Task.sleep(for: .milliseconds(160))
            playTone(frequency: 233.08, duration: 0.28, amplitude: 0.2)  // Bb3
        }
    }

    func playDraw() {
        Task {
            playTone(frequency: 440, duration: 0.14, amplitude: 0.25)    // A4
            try? await Task.sleep(for: .milliseconds(150))
            playTone(frequency: 440, duration: 0.14, amplitude: 0.18)    // A4
        }
    }

    // MARK: - Tone Synthesis

    private func playTone(frequency: Double, duration: Double, amplitude: Double) {
        guard let data = generateWAV(frequency: frequency, duration: duration, amplitude: amplitude) else { return }
        do {
            let player = try AVAudioPlayer(data: data)
            player.play()
            players.append(player)
            players.removeAll { !$0.isPlaying }
        } catch {}
    }

    private func generateWAV(frequency: Double, duration: Double, amplitude: Double) -> Data? {
        let numSamples = Int(sampleRate * duration)
        let numChannels: Int16 = 1
        let bitsPerSample: Int16 = 16
        let byteRate = Int32(sampleRate) * Int32(numChannels) * Int32(bitsPerSample / 8)
        let blockAlign = numChannels * (bitsPerSample / 8)
        let dataSize = Int32(numSamples * Int(blockAlign))
        let fileSize = 36 + dataSize

        var wav = Data()

        // RIFF header
        wav.append(contentsOf: "RIFF".utf8)
        appendInt32(&wav, fileSize)
        wav.append(contentsOf: "WAVE".utf8)

        // fmt chunk
        wav.append(contentsOf: "fmt ".utf8)
        appendInt32(&wav, 16)
        appendInt16(&wav, 1) // PCM
        appendInt16(&wav, numChannels)
        appendInt32(&wav, Int32(sampleRate))
        appendInt32(&wav, byteRate)
        appendInt16(&wav, blockAlign)
        appendInt16(&wav, bitsPerSample)

        // data chunk
        wav.append(contentsOf: "data".utf8)
        appendInt32(&wav, dataSize)

        // PCM samples: fundamental + 2nd harmonic, exponential decay
        for i in 0..<numSamples {
            let t = Double(i) / sampleRate
            let attack = min(1.0, t / 0.003)
            let decay = exp(-t * 7.0 / duration)
            let envelope = attack * decay

            let fundamental = sin(2.0 * .pi * frequency * t)
            let harmonic2 = sin(2.0 * .pi * frequency * 2.0 * t) * 0.25
            let harmonic3 = sin(2.0 * .pi * frequency * 3.0 * t) * 0.08

            let sample = (fundamental + harmonic2 + harmonic3) * amplitude * envelope
            let clamped = max(-1.0, min(1.0, sample))
            appendInt16(&wav, Int16(clamped * Double(Int16.max)))
        }

        return wav
    }

    // MARK: - Binary Helpers

    private func appendInt16(_ data: inout Data, _ value: Int16) {
        withUnsafeBytes(of: value.littleEndian) { data.append(contentsOf: $0) }
    }

    private func appendInt32(_ data: inout Data, _ value: Int32) {
        withUnsafeBytes(of: value.littleEndian) { data.append(contentsOf: $0) }
    }
}
