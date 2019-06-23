import UIKit
import Rotary

class DancersViewController: UIViewController {
    
    @IBOutlet private weak var label: UILabel! {
        didSet {
            label.font = FontManager.body
            label.textColor = ColourManager.text
        }
    }
    
    private let wheelControl = RotaryWheelControl<Dancer>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColourManager.background
        navigationItem.title = "Dancers"
        wheelControl.translatesAutoresizingMaskIntoConstraints = false
        wheelControl.styling = RotaryWheelStyling(font: FontManager.subtitle, textColour: ColourManager.text, spindleColour: ColourManager.spindle, backgroundColour: ColourManager.wheel, innerGrooveColour: ColourManager.groove, outerGrooveColour: ColourManager.groove)
        wheelControl.rotationEnded = { [unowned self] dancer in
            self.label.attributedText = NSMutableAttributedString(string: "").normal("The current selection is ").bold(dancer.name).copy() as? NSAttributedString
        }
        wheelControl.layout([
            Dancer(name: "Joanne", style: Genre(name: "Jazz")),
            Dancer(name: "Stacey", style: Genre(name: "Tap")),
            Dancer(name: "Rhian", style: Genre(name: "Lyrical")),
            Dancer(name: "Cathy", style: Genre(name: "Ballet")),
            Dancer(name: "Robin", style: Genre(name: "Street"))
            ])
        view.addSubview(wheelControl)
        view.addConstraints(makeConstraints(forViews: ["wheel": wheelControl]))
        let selector = #selector(swiped(_:))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: selector)
        swipeDown.direction = .down
        wheelControl.addGestureRecognizer(swipeDown)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: selector)
        swipeUp.direction = .up
        wheelControl.addGestureRecognizer(swipeUp)
    }
    
    @objc
    private func swiped(_ sender: UISwipeGestureRecognizer) {
        if case .up = sender.direction {
            wheelControl.selectNextOptionClockwise()
        }
        if case .down = sender.direction {
            wheelControl.selectNextOptionAntiClockwise()
        }
    }
    
    private func makeConstraints(forViews views: [String: Any]) -> [NSLayoutConstraint] {
        let wheel: RotaryWheelControl<Dancer> = views["wheel"] as! RotaryWheelControl<Dancer>
        var collector = [NSLayoutConstraint]()
        collector.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[wheel(800)]", options: [], metrics: nil, views: views))
        collector.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[wheel(==800)]", options: [], metrics: nil, views: views))
        collector.append(NSLayoutConstraint(item: wheel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        collector.append(NSLayoutConstraint(item: wheel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        return collector
    }
}
