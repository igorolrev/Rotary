import UIKit

public class GestureSelectionWheelControl<T>: UIControl where T: WheelOption {
    
    var wheelView: RotaryWheelView<T>!
    
    public typealias OptionConsumer = (T) -> Void
    
    public var rotationEnded: OptionConsumer?
    
    public var styling: RotaryWheelStyling? {
        didSet {
            wheelView.styling = styling
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        wheelView = RotaryWheelView(frame: bounds)
        wheelView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wheelView)
        wheelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        wheelView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        wheelView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        wheelView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    public func layout(_ sectors: [T]) {
        wheelView.layout(sectors)
        rotationEnded?(sectors.first!)
    }
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        return wheelView.beginTrackingSwipeGesture(beginningAtPoint: touchPoint)
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        wheelView.continueTrackingSwipeGesture(atTouchPoint: touchPoint)
        return true
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        let touchPoint = touch!.location(in: self)
        wheelView.finishTrackingSwipeGesture(atFinalTouchPoint: touchPoint) { sector in
            if sector != nil {
                self.rotationEnded?(sector!.wheelOption)
            }
        }
        super.endTracking(touch, with: event)
    }
    
}

public class RotaryWheelControl<T: WheelOption>: GestureSelectionWheelControl<T> {
    
    public func selectNextOptionClockwise() {
        if wheelView.isTracking {
            return
        }
        wheelView.selectNextSectorClockwise { sector in
            self.rotationEnded?(sector.wheelOption)
        }
    }
    
    public func selectNextOptionAntiClockwise() {
        if wheelView.isTracking {
            return
        }
        wheelView.selectNextSectorAntiClockwise { sector in
            self.rotationEnded?(sector.wheelOption)
        }
    }
    
}
