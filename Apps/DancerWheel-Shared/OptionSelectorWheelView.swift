import UIKit
import Rotary

class OptionSelectorWheelView: UIView {
    
    static func load() -> OptionSelectorWheelView {
        let wheel = Bundle(for: OptionSelectorWheelView.self).loadNibNamed("OptionSelectorWheelView", owner: nil, options: nil)!.first as! OptionSelectorWheelView
        wheel.translatesAutoresizingMaskIntoConstraints = false
        return wheel
    }
    
    @IBOutlet private weak var selectionBar: UIView! {
        didSet {
            selectionBar.backgroundColor = ColourManager.selectionBar
        }
    }
    
    let wheelControl = RotaryWheelControl<Dancer>()
    
    @IBOutlet private weak var wheelContainer: UIView! {
        didSet {
            wheelControl.translatesAutoresizingMaskIntoConstraints = false
            wheelControl.styling = RotaryWheelStyling(font: FontManager.subtitle, textColour: ColourManager.text, spindleColour: ColourManager.spindle, backgroundColour: ColourManager.wheel, innerGrooveColour: ColourManager.groove, outerGrooveColour: ColourManager.groove)
            wheelContainer.addSubview(wheelControl)
            wheelControl.topAnchor.constraint(equalTo: wheelContainer.topAnchor).isActive = true
            wheelControl.leftAnchor.constraint(equalTo: wheelContainer.leftAnchor).isActive = true
            wheelControl.rightAnchor.constraint(equalTo: wheelContainer.rightAnchor).isActive = true
            wheelControl.bottomAnchor.constraint(equalTo: wheelContainer.bottomAnchor).isActive = true
        }
    }
    
    @IBAction private func tapGestureRecognizerTop(_ sender: UITapGestureRecognizer) {
        wheelControl.selectNextOptionClockwise()
    }
    
    @IBAction private func tapGestureRecognizerBottom(_ sender: UITapGestureRecognizer) {
        wheelControl.selectNextOptionAntiClockwise()
    }
}
