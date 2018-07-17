import UIKit

public class SineWaveView: UIView {

    /// Number of unit / pixel per drawed line
    public var unitPerLine: CGFloat = 4.0

    /// Number of unit per "hertz"
    public var unitPerHertz: CGFloat = 200.0

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
        let path = buildPath(forWave: wave)
        let pathLayer = CAShapeLayer()
        pathLayer.frame = bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = wave.color.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 2
        return pathLayer
    }

    private func buildPath(forWave wave: SineWave) -> UIBezierPath {
        return buildPath(withAmplitude: wave.amplitude, frequency: wave.frequency, offset: wave.offset, inRect: bounds)
    }

    private func buildPath(withAmplitude amplitude: CGFloat,
                           frequency: CGFloat,
                           offset: CGFloat,
                           inRect rect: CGRect) -> UIBezierPath {
        let width = rect.width
        let height = rect.height
        let origin = CGPoint(x: -unitPerHertz / frequency, y: height / 2)

        let path = UIBezierPath()
        path.move(to: origin)

        for deltaX in stride(from: unitPerLine,
                             to: width + 2 * unitPerHertz + unitPerLine,
                             by: unitPerLine) {
            let x = origin.x + deltaX
            let y = origin.y - CGFloat(sin(2 * (offset + frequency * deltaX / unitPerHertz) * .pi)) * height * amplitude / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }
        if (offset != 0) {
            path.apply(CGAffineTransform(translationX: offset * unitPerHertz / frequency, y: 0))
        }

        return path
    }
}
