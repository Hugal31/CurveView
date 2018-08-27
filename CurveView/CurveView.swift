import UIKit

public class CurveView: UIView {

    /// Number of unit / pixel per drawed line.
    public var resolution: CGFloat = 4.0

    /// Number of pixel for one unit
    public var pixelPerUnit: CGFloat = 200.0

    public var curves: [(Curve, UIColor)] {
        get {
            return curvesLayers.map { ($0.0, UIColor(cgColor: $0.1.strokeColor!)) }
        }
        set {
            updateCurves(curves: newValue)
        }
    }

    private var curvesLayers: [(Curve, CAShapeLayer)] = []

    public func updateWave(fromCurveIndex: Int, to toCurve: Curve) {
        let curveLayer = curvesLayers[fromCurveIndex].1

        let newPath = buildPath(forCurve: toCurve).cgPath
        curveLayer.path = newPath
    }

    private func updateCurves(curves: [(Curve, UIColor)]) {
        curvesLayers.forEach { $0.1.removeFromSuperlayer() }
        curvesLayers.removeAll()

        for (curve, color) in curves {
            let pathLayer = buildShapeLayer(forCurve: curve, withColor: color)
            layer.addSublayer(pathLayer)

            curvesLayers.append((curve, pathLayer))
        }
    }

    private func buildShapeLayer(forCurve curve: Curve, withColor color: UIColor) -> CAShapeLayer {
        let path = buildPath(forCurve: curve)
        let pathLayer = AnimatablePathShapehLayer()
        pathLayer.frame = bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = color.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 2
        return pathLayer
    }

    private func buildPath(forCurve curve: Curve) -> UIBezierPath {
        let width = bounds.width
        let height = bounds.height
        let middle = height / 2
        let origin = CGPoint(x: 0, y: middle + CGFloat(curve.getValue(forX: 0)) * pixelPerUnit)

        let path = UIBezierPath()
        path.move(to: origin)

        for x in stride(from: resolution, to: width, by: resolution) {
            let y = middle + CGFloat(curve.getValue(forX: Double(x / pixelPerUnit))) * pixelPerUnit
            path.addLine(to: CGPoint(x: x, y: y))
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
