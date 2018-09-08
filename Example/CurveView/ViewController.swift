import CurveView
import UIKit

class ViewController: UIViewController {

    @IBOutlet var sineWaveView: CurveView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sineWaveView.minX = -CGFloat.pi
        sineWaveView.maxX = CGFloat.pi
        sineWaveView.minY = -2
        sineWaveView.maxY = 2
        sineWaveView.curves = [
            (SineWaveCurve(amplitude: 1.0, frequency: 1.0, phase: 0), .red),
            //(SineWaveCurve(amplitude: 0.8, frequency: 2.0, phase: 0), .green),
            //(SineWaveCurve(amplitude: 0.6, frequency: 3.0, phase: 0), .purple),
            //(SineWaveCurve(amplitude: 0.4, frequency: 5.0, phase: 1), .yellow),
        ]

//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.sineWaveView.updateWave(fromCurveIndex: 0, to: SineWaveCurve(amplitude: 2.0, frequency: 1.0, offset: 0))
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.sineWaveView.updateWave(fromCurveIndex: 0, to: SineWaveCurve(amplitude: 2.0, frequency: 2.0, offset: 0))
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    self.sineWaveView.updateWave(fromCurveIndex: 0, to: SineWaveCurve(amplitude: 2.0, frequency: 2.0, offset: 1))
//                }
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

