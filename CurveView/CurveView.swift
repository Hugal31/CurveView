import UIKit

public class CurveView: UIView {

    /// Number of unit / pixel per drawed line.
    public var resolution: CGFloat = 4.0

    public var minX: CGFloat = -1.0
    public var maxX: CGFloat = 1.0
    public var minY: CGFloat = -1.0
    public var maxY: CGFloat = 1.0

    public var curves: [(Curve, UIColor)] {
        get {
            return curvesLayers.map { ($0.0, UIColor(cgColor: $0.1.strokeColor!)) }
        }
        set {
            updateCurves(curves: newValue)
        }
    }

    private let axesLayer = CAShapeLayer()

    private var curvesLayers: [(Curve, CAShapeLayer)] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        drawAxes()
        updateCurves(curves: curves)
    }

    private func commonInit() {
        axesLayer.frame = bounds
        axesLayer.strokeColor = UIColor.black.cgColor
        axesLayer.lineWidth = 1
        axesLayer.fillColor = nil
        layer.addSublayer(axesLayer)

        drawAxes()
    }

    public func updateWave(fromCurveIndex: Int, to toCurve: Curve) {
        let curveLayer = curvesLayers[fromCurveIndex].1

        let newPath = buildPath(forCurve: toCurve).cgPath
        curveLayer.path = newPath
    }

    private func drawAxes() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 2))
        path.move(to: CGPoint(x: bounds.width / 2, y: 0))
        path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))

        axesLayer.path = path.cgPath
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
        let horizontalPixelPerUnit = width / (maxX - minX)
        let verticalPixelPerUnit = height / (maxY - minY)
        let middle = height / 2
        let origin = CGPoint(x: 0, y: middle - CGFloat(curve.getValue(forX: Double(minX))) * verticalPixelPerUnit)

        let path = UIBezierPath()
        path.move(to: origin)

        for x in stride(from: resolution, to: width, by: resolution) {
            let graphX = Double(minX + x / horizontalPixelPerUnit)
            let y = middle - CGFloat(curve.getValue(forX: graphX)) * verticalPixelPerUnit
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
