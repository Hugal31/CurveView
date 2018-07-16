import UIKit

public class SineWaveView: UIView {

    public var waves: [SineWave] = [] {
        didSet {
            updateWaves()
        }
    }

    private func updateWaves() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let fromPath = buildPath(withAmplitude: 1.0, frequency: 0.5, inRect: bounds)

        for wave in waves {
            let path = buildPath(withAmplitude: wave.amplitude,
                                 frequency: wave.frequency,
                                 inRect: bounds)

            let pathLayer = CAShapeLayer()
            pathLayer.frame = bounds
            pathLayer.path = path.cgPath
            pathLayer.strokeColor = wave.color.cgColor
            pathLayer.fillColor = nil
            pathLayer.lineWidth = 2
            pathLayer.lineJoin = kCALineJoinBevel
            pathLayer.strokeStart = 0.0
            layer.addSublayer(pathLayer)

            let animation = CABasicAnimation(keyPath: "path")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.fromValue = fromPath.cgPath
            animation.toValue = path.cgPath
            animation.duration = 4.0

            pathLayer.add(animation, forKey: "path")
        }
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
            let y = origin.y - CGFloat(sin(advancement * .pi * frequency)) * height * amplitude / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}
