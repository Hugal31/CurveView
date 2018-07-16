import UIKit

public class SineWaveView: UIView {

    /// Number of unit / pixel per drawed line
    private static let unitPerLine: CGFloat = 4.0

    public var waves: [SineWave] = [] {
        didSet {
            updateWaves()
        }
    }

    private func updateWaves() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        for wave in waves {
            let pathLayer = buildShapeLayer(forWave: wave)
            layer.addSublayer(pathLayer)
        }
    }

    private func buildShapeLayer(forWave wave: SineWave) -> CAShapeLayer {
        let path = buildPath(withAmplitude: wave.amplitude, frequency: wave.frequency, inRect: bounds)
        let pathLayer = CAShapeLayer()
        pathLayer.frame = bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = wave.color.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 2
        pathLayer.lineJoin = kCALineJoinBevel
        pathLayer.strokeStart = 0.0
        return pathLayer
    }

    private func buildPath(withAmplitude amplitude: CGFloat, frequency: CGFloat, inRect rect: CGRect) -> UIBezierPath {
        let width = rect.width
        let height = rect.height
        let origin = CGPoint(x: 0, y: height / 2)

        let path = UIBezierPath()
        path.move(to: origin)

        let precision = Int(width / SineWaveView.unitPerLine)
        for point in 0...precision {
            let advancement = CGFloat(point) / CGFloat(precision)
            let x = origin.x + advancement * width
            let y = origin.y - CGFloat(sin(advancement * .pi * frequency * 2.0)) * height * amplitude / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}
