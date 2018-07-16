import UIKit

public class SineWaveView: UIView {

    public var waves: [SineWave] = [] {
        didSet {
            updateWaves()
        }
    }

    private func updateWaves() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        for wave in waves {
            addShapeLayer(forPath: buildPath(withAmplitude: wave.amplitude,
                                             frequency: wave.frequency,
                                             inRect: bounds).cgPath,
                          color: wave.color.cgColor)
            addShapeLayer(forPath: buildBezierPath(withAmplitude: wave.amplitude,
                                                   frequency: wave.frequency,
                                                   inRect: bounds).cgPath,
                          color: wave.color.withAlphaComponent(0.5).cgColor)
        }
    }

    private func addShapeLayer(forPath path: CGPath, color: CGColor) {
        let basicPath = buildBezierPath(withAmplitude: 1.0, frequency: 0.5, inRect: bounds)
        let pathLayer = CAShapeLayer()
        pathLayer.frame = bounds
        pathLayer.path = path
        pathLayer.strokeColor = color
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 2
        pathLayer.lineJoin = kCALineJoinBevel
        pathLayer.strokeStart = 0.0
        layer.addSublayer(pathLayer)

        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = basicPath.cgPath
        animation.toValue = path
        animation.duration = 3
        pathLayer.add(animation, forKey: nil)
    }

    private func buildPath(withAmplitude amplitude: CGFloat, frequency: CGFloat, inRect rect: CGRect) -> UIBezierPath {
        let width = rect.width
        let height = rect.height
        let origin = CGPoint(x: 0, y: height / 2)

        let path = UIBezierPath()
        path.move(to: origin)

        let precision = Int(width / 5)
        for point in 0...precision {
            let advancement = CGFloat(point) / CGFloat(precision)
            let x = origin.x + advancement * width
            let y = origin.y - CGFloat(sin(advancement * .pi * frequency * 2.0)) * height * amplitude / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }

    private func buildBezierPath(withAmplitude amplitude: CGFloat, frequency: CGFloat, inRect rect: CGRect) -> UIBezierPath {
        let width = rect.width
        let height = rect.height
        let origin = CGPoint(x: -0.5 / (frequency * 2.0) * width, y: height / 2.0)
        let nbpoints = Int(ceil(frequency * 2)) + 1

        let path = UIBezierPath()
        path.move(to: CGPoint(x: -1.5 / (frequency * 2.0) * width, y: -amplitude / 2.0 * height))

        for i in 0...nbpoints {
            let deltaY = amplitude / 2.0 * height
            let previousY = origin.y + (i % 2 == 1 ? deltaY : -deltaY)
            let previousX = origin.x + CGFloat(i - 1) / (frequency * 2.0) * width
            let x = origin.x + CGFloat(i) / (frequency * 2.0) * width
            let y = origin.y + (i % 2 == 0 ? deltaY : -deltaY)
            path.addCurve(to: CGPoint(x: x, y: y),
                          controlPoint1: CGPoint(x: (previousX + x) / 2.0, y: previousY),
                          controlPoint2: CGPoint(x: (previousX + x) / 2.0, y: y))
        }
        return path
    }
}
