public struct SineWave {
    public let amplitude: CGFloat

    public let frequency: CGFloat

    /// Offset of the curve, usually between 0 and 1
    public let offset: CGFloat

    public let color: UIColor

    public init(amplitude: CGFloat, frequency: CGFloat, offset: CGFloat, color: UIColor) {
        self.amplitude = amplitude
        self.frequency = frequency
        self.offset = offset
        self.color = color
    }
}
