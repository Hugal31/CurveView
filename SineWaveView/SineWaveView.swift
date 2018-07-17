import UIKit

public class SineWaveView: UIView {

    /// Number of unit / pixel per drawed line
    public var unitPerLine: CGFloat = 4.0

    /// Number of unit per "hertz"
    public var unitPerHertz: CGFloat = 200.0

    public var waves: [SineWave] {
        get {
            return wavesLayers.map { $0.0 }
        }
        set {
            updateWaves(waves: newValue)
        }
    }

    private var wavesLayers: [(SineWave, CAShapeLayer)] = []

    public func updateWave(from fromWave: SineWave, to toWave: SineWave) {
        let waveLayer = wavesLayers.first { $0.0 == fromWave }!.1

        let newPath = buildPath(forWave: toWave).cgPath
        waveLayer.path = newPath
        waveLayer.strokeColor = toWave.color.cgColor
    }

    private func updateWaves(waves: [SineWave]) {
        wavesLayers.forEach { $0.1.removeFromSuperlayer() }
        wavesLayers.removeAll()

        for wave in waves {
            let pathLayer = buildShapeLayer(forWave: wave)
            layer.addSublayer(pathLayer)

            wavesLayers.append((wave, pathLayer))
        }
    }

    private func buildShapeLayer(forWave wave: SineWave) -> CAShapeLayer {
        let path = buildPath(forWave: wave)
        let pathLayer = AnimatablePathShapehLayer()
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

/// A shape layer that animate the change of its path.
private class AnimatablePathShapehLayer: CAShapeLayer {
    override init() {
        super.init()
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override class func needsDisplay(forKey key: String) -> Bool {
        return key == "path" || super.needsDisplay(forKey: key)
    }

    override func action(forKey event: String) -> CAAction? {
        if event == "path" {
            let animation = CABasicAnimation(keyPath: event)
            let fromPath = presentation()?.value(forKey: event) ?? self.value(forKey: event)
            animation.fromValue = fromPath
            animation.toValue = nil
            return animation
        }
        return super.action(forKey: event)
    }
}
