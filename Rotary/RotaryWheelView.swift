import UIKit

class RotaryWheelView<T>: UIView, RotaryWheelTrackDatasource where T: WheelOption {
    
    private var track: RotaryWheelTrack<T>? {
        didSet {
            track?.datasource = self
        }
    }
    
    var styling: RotaryWheelStyling? {
        didSet {
            layoutSubviews()
        }
    }
    
    ///// RotaryWheelTrackDatasource : BEGIN : /////
    
    func currentSize() -> CGSize {
        return bounds.size
    }
    
    ///// RotaryWheelTrackDatasource : END : /////
    
    private var optionViews: [UIView]?
    
    private var innerCircle: CAShapeLayer?
    
    private var outerCircle: CAShapeLayer?
    
    private var thinInnerCircle: CAShapeLayer?
    
    private var thinOuterCircle: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isUserInteractionEnabled = false
    }
    
    func layout(_ options: [T]) {
        let sectors: [RotaryWheelSector<T>] = options.map { (option) -> RotaryWheelSector<T> in
            RotaryWheelSector<T>(option: option)
        }
        self.track = RotaryWheelTrack<T>(withSectors: sectors)
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        thinOuterCircle?.removeFromSuperlayer()
        thinInnerCircle?.removeFromSuperlayer()
        outerCircle?.removeFromSuperlayer()
        optionViews?.forEach { (optionView) in
            optionView.removeFromSuperview()
        }
        innerCircle?.removeFromSuperlayer()
        if let outerCircle = track?.makeOuterCircle(withColour: styling?.backgroundColour) {
            layer.addSublayer(outerCircle)
            self.outerCircle = outerCircle
        }
        optionViews = track?.makeWheelOptions(withFont: styling?.font, withTextColour: styling?.textColour)
        optionViews?.forEach { (optionView) in
            addSubview(optionView)
        }
        if let innerCircle = track?.makeInnerCircle(withColour: styling?.spindleColour) {
            layer.addSublayer(innerCircle)
            self.innerCircle = innerCircle
        }
        if let thinInnerCircle = track?.makeThinInnerCircle(withColour: styling?.innerGrooveColour) {
            layer.addSublayer(thinInnerCircle)
            self.thinInnerCircle = thinInnerCircle
        }
        if let thinOuterCircle = track?.makeThinOuterCircle(withColour: styling?.outerGrooveColour) {
            layer.addSublayer(thinOuterCircle)
            self.thinOuterCircle = thinOuterCircle
        }
        super.layoutSubviews()
    }
    
    ///// Sector Selection : BEGIN : /////
    
    func selectNextSectorClockwise(withCompletion completion: @escaping (RotaryWheelSector<T>) -> ()) {
        if let sector = track?.nextSectorClockwise() {
            isTracking = true
            rotateWheel(byAmount: CGFloat(sector.angleSize), withCompletion: {
                self.track!.currentSector = sector
                completion(sector)
                self.isTracking = false
            })
        }
    }
    
    func selectNextSectorAntiClockwise(withCompletion completion: @escaping (RotaryWheelSector<T>) -> ()) {
        if let sector = track?.nextSectorAntiClockwise() {
            isTracking = true
            rotateWheel(byAmount: CGFloat(-sector.angleSize), withCompletion: {
                self.track!.currentSector = sector
                completion(sector)
                self.isTracking = false
            })
        }
    }
    
    private func rotateWheel(byAmount radians: CGFloat, withCompletion completion: (() -> ())? = nil) {
        let t = transform.rotated(by: CGFloat(radians))
        animateTransition(toTransform: t, withCompletion: completion)
    }
    
    private func animateTransition(toTransform transform: CGAffineTransform, withCompletion completion: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = transform
        }) { _ in completion?() }
    }
    
    ///// Sector Selection : END : /////
    
    ///// Tracking : BEGIN : /////
    
    var isTracking = false
    
    func beginTrackingSwipeGesture(beginningAtPoint touchPoint: CGPoint) -> Bool {
        if (isTracking || track?.shouldRotate(atTouchPoint: touchPoint) ?? false) == false {
            return false
        }
        isTracking = true
        track?.startTouch = touchPoint
        track?.startTransform = transform
        return true
    }
    
    func continueTrackingSwipeGesture(atTouchPoint touchPoint: CGPoint) {
        if let transform = track?.transform(atSwipePoint: touchPoint) {
            self.transform = transform
        }
    }
    
    func finishTrackingSwipeGesture(atFinalTouchPoint touchPoint: CGPoint, withCompletion completion: @escaping (RotaryWheelSector<T>?) -> Void) {
        if let transform = track?.reset(transform: transform, atRadians: radians, atSwipeEndPoint: touchPoint) {
            animateTransition(toTransform: transform) {
                let currentSector = self.track?.establishCurrentSector(atAngle: self.radians)
                completion(currentSector)
            }
        } else {
            let currentSector = track?.establishCurrentSector(atAngle: radians)
            completion(currentSector)
        }
        isTracking = false
    }
    
    ///// Tracking : END : /////
    
}
