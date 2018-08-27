import Foundation

public protocol Curve {
    func getValue(forX: Double) -> Double
}

/// A curve that is the sum of other curves
public struct SumCurve: Curve {
    public let curves: [Curve]

    public init(curves: [Curve]) {
        self.curves = curves
    }

    public func getValue(forX x: Double) -> Double {
        return curves.reduce(0.0) { $0 + $1.getValue(forX: x) }
    }
}

public struct SineWaveCurve: Equatable, Curve {
    public let amplitude: Double

    public let frequency: Double

    /// Offset of the curve, between -1 and 1
    public let phase: Double

    public init(amplitude: Double, frequency: Double, offset: Double) {
        self.amplitude = amplitude
        self.frequency = frequency
        self.phase = offset
    }

    public func getValue(forX x: Double) -> Double {
        return sin(Double.pi * frequency * x + phase) * amplitude
    }
}
