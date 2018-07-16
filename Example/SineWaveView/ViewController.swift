import SineWaveView
import UIKit

class ViewController: UIViewController {

    @IBOutlet var sineWaveView: SineWaveView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sineWaveView.waves = [
            SineWave(amplitude: 1.0, frequency: 1.0, color: .red),
            SineWave(amplitude: 0.8, frequency: 2.0, color: .green),
            SineWave(amplitude: 0.5, frequency: 3.0, color: .purple),
            SineWave(amplitude: 0.4, frequency: 5.0, color: .yellow),
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

