import UIKit

protocol RotaryWheelTrackDatasource: class {
    func currentSize() -> CGSize
}

class RotaryWheelTrack<T> where T: WheelOption {
    
    private var size: CGSize! {
        return datasource!.currentSize()
    }
    
    weak var datasource: RotaryWheelTrackDatasource?
    
    private var centre: CGPoint {
        let x = self.size.width/2.0
        let y = self.size.height/2.0
        return CGPoint(x: x, y: y)
    }
    
    private let sectors: [RotaryWheelSector<T>]
    
    private var squashedModeEnabled: Bool {
        return sectors.count < 5
    }
    
    private static func shouldEnableSquashedMode(totalSectors: Int) -> Bool {
        return totalSectors < 5
    }
    
    init(withSectors sectors: [RotaryWheelSector<T>]) {
        let totalSectors = sectors.count
        let isEven = totalSectors % 2 == 0
        var mid: Double = 0
        let isEnabled = RotaryWheelTrack<T>.shouldEnableSquashedMode(totalSectors: totalSectors)
        let arc = RotaryWheelSector<T>.angle(squashedModeEnabled: isEnabled, totalSectors: totalSectors)
        let halfArc = arc / 2.0
        var collector = [RotaryWheelSector<T>]()
        for (index, _) in sectors.enumerated() {
            var sector = sectors[index]
            var min = mid - halfArc
            let max = mid + halfArc
            sector.minValue = min
            sector.midValue = mid
            sector.maxValue = max
            sector.angleSize = arc
            if isEven {
                if min < -Double.pi {
                    mid = -mid
                }
                mid -= arc
            } else {
                mid -= arc
                min = mid - halfArc
                if min < -Double.pi {
                    mid = -mid;
                    mid -= arc
                }
            }
            collector.append(sector)
        }
        self.sectors = collector
    }
    
    private var optionWidth: CGFloat {
        return size.width * 0.5
    }
    
    private var optionHeight: CGFloat {
        return size.height * 0.2
    }
    
    private var labelInset: CGFloat {
        return optionWidth * 0.1
    }
    
    private var labelWidth: CGFloat {
        return (optionWidth * 0.8) - (labelInset * 2.0)
    }
    
    private var labelHeight: CGFloat {
        return optionHeight
    }
    
    private var innerCircleRadius: CGFloat {
        return optionWidth - labelWidth - (labelInset * 2.0)
    }
    
    private var thinInnerCircleRadius: CGFloat {
        return innerCircleRadius + labelInset
    }
    
    private var outerCircleRadius: CGFloat {
        return optionWidth
    }
    
    private var thinOuterCircleRadius: CGFloat {
        return thinInnerCircleRadius + labelWidth
    }
    
    func makeWheelOptions(withFont font: UIFont? = UIFont.systemFont(ofSize: 12.0), withTextColour colour: UIColor? = .black) -> [UIView] {
        var collector = [UIView]()
        for (index, sector) in sectors.enumerated() {
            let label = UILabel(frame: CGRect(x: labelInset, y: 0, width: labelWidth, height: labelHeight))
            label.text = sector.title
            label.font = font
            label.textColor = colour
            label.tag = index
            label.numberOfLines = 2
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.isAccessibilityElement = true
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: optionWidth, height: optionHeight))
            containerView.addSubview(label)
            containerView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            containerView.layer.position = centre
            let rotationAngle = CGFloat(sector.angleSize * Double(index))
            containerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            collector.append(containerView)
        }
        return collector
    }
    
    func makeThinInnerCircle(withColour colour: UIColor? = .black) -> CAShapeLayer {
        let x = centre.x - thinInnerCircleRadius
        let y = centre.y - thinInnerCircleRadius
        let diameter = thinInnerCircleRadius * 2
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = colour?.cgColor //Colours.darkRed.cgColor
        shape.lineWidth = 2
        shape.path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: diameter, height: diameter)).cgPath
        return shape
    }
    
    func makeInnerCircle(withColour colour: UIColor? = .black) -> CAShapeLayer {
        let x = centre.x - innerCircleRadius
        let y = centre.y - innerCircleRadius
        let diameter = innerCircleRadius * 2
        let shape = CAShapeLayer()
        shape.fillColor = colour?.cgColor
        shape.path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: diameter, height: diameter)).cgPath
        return shape
    }
    
    func makeOuterCircle(withColour colour: UIColor? = .black) -> CAShapeLayer {
        let x = centre.x - outerCircleRadius
        let y = centre.y - outerCircleRadius
        let diameter = outerCircleRadius * 2
        let shape = CAShapeLayer()
        shape.fillColor = colour?.cgColor
        shape.path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: diameter, height: diameter)).cgPath
        return shape
    }
    
    func makeThinOuterCircle(withColour colour: UIColor? = .black) -> CAShapeLayer {
        let x = centre.x - thinOuterCircleRadius
        let y = centre.y - thinOuterCircleRadius
        let diameter = thinOuterCircleRadius * 2
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = colour?.cgColor //Colours.darkRed.cgColor
        shape.lineWidth = 2
        shape.path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: diameter, height: diameter)).cgPath
        return shape
    }
    
    func nextSectorClockwise() -> RotaryWheelSector<T>? {
        let isFirst = sectors.first == currentSector
        if squashedModeEnabled && isFirst {
            return nil
        } else if isFirst {
            return sectors.last!
        }
        let index = sectors.firstIndex { $0 == currentSector }!
        return sectors[index - 1]
    }
    
    func nextSectorAntiClockwise() -> RotaryWheelSector<T>? {
        let index = sectors.firstIndex { $0 == currentSector }!
        let isLast = sectors.count - 1 == index
        if squashedModeEnabled && isLast {
            return nil
        }
        if isLast {
            return sectors.first!
        }
        return sectors[index + 1]
    }
    
    /// This value is established during any sector query and is passed in when 'selectNextClockwise' or 'selectNextAntiClockwise' is called.
    lazy var currentSector: RotaryWheelSector = {
        return self.sectors.first!
    }()
    
    /// The selected sector at a given angle of rotation. The selection is considered to be the leftmost point of the x-axis.
    ///
    /// - Parameter angle: The angle of rotation, expressed in radians.
    /// - Returns: The seleected sector
    func establishCurrentSector(atAngle angle: Double) -> RotaryWheelSector<T> {
        if currentSector.isWithinRange(radians: angle) {
            return currentSector
        }
        var found = false
        for sector in angle > 0 ? sectors.reversed() : sectors {
            if sector.isWithinRange(radians: angle) {
                currentSector = sector
                found = true
                break
            }
        }
        if found == false {
            currentSector = angle > 0 ? sectors.first! : sectors.last!
        }
        return currentSector
    }
    
    func shouldRotate(atTouchPoint touchPoint: CGPoint) -> Bool {
        let distance = CGFloat(centre.distance(toPoint: touchPoint))
        if distance < optionHeight || distance > optionWidth {
            return false
        }
        return true
    }
    
    var startTouch: CGPoint!
    
    /// The angle generated by the users initial touch, relative to the x-axis.
    private var initialAngle: Float! {
        return self.centre.angleFromLongitude(toPoint: self.startTouch)
    }
    
    /// The total angle produced by the users swipe gesture, relative to the centre point of the wheel. The angle represents the arc between the users initial touch and the users final touch.
    ///
    /// - Parameter point: the final touch point of the users swipe gesture
    /// - Returns: A positive or negative angle, in radians, relative to the centre point of the circle. The angle is positive for counter-clockwise angles (upper half-plane, y > 0), and negative for clockwise angles (lower half-plane, y < 0).
    func swipeAngle(toPoint point: CGPoint) -> CGFloat {
        return CGFloat(initialAngle - centre.angleFromLongitude(toPoint: point))
    }
    
    var startTransform: CGAffineTransform!
    
    /// Makes a suitable transform for the wheel at a particular phase of the swipe gesture.
    ///
    /// - Parameter touchPoint: The current touch point of an ongoing swipe gesture.
    /// - Returns: The transform for the wheel at this particular phase of the swipe gesture.
    func transform(atSwipePoint touchPoint: CGPoint) -> CGAffineTransform {
        let angle = swipeAngle(toPoint: touchPoint)
        //        let scale = wheelScale(atSwipePoint: touchPoint)
        return startTransform.rotated(by: angle)//.scaledBy(x: scale, y: scale)
    }
    
    /// Makes a suitable transform for the wheel at the final phase of the swipe gesture.
    ///
    /// - Parameters:
    ///   - transform: The current transform of the wheel.
    ///   - radians: The current radians of rotation from the start point, considered to be at the x-axis in the left hemisphere.
    ///   - touchPoint: The final touch point of the swipe gesture.
    /// - Returns: The transform for the wheel at the final phase of the swipe gesture.
    func reset(transform: CGAffineTransform, atRadians radians: Double, atSwipeEndPoint touchPoint: CGPoint) -> CGAffineTransform {
        let rotation = CGFloat(-(radians - establishCurrentSector(atAngle: radians).midValue))
        //        let scale = 1 + (1 - sqrt(pow(transform.a, 2)+pow(transform.c, 2)))
        return transform.rotated(by: rotation)//.scaledBy(x: scale, y: scale)
    }
    
    private func wheelScale(atSwipePoint touchPoint: CGPoint) -> CGFloat {
        var a = swipeAngle(toPoint: touchPoint)
        let squeezeSize = size.width * 0.4
        let totalSectors = sectors.count
        if a < 0 {
            a = abs(a)
        }
        let sa = CGFloat(RotaryWheelSector<T>.angle(squashedModeEnabled: squashedModeEnabled, totalSectors: totalSectors))
        let remainingAngle = a.truncatingRemainder(dividingBy: sa) //this is a % sa in swift 2
        let progress = remainingAngle / sa
        let proportionSqueeze = progress > 0.5 ? squeezeSize * progress : squeezeSize * (1-progress)
        let invertedProportionSqueeze = squeezeSize - proportionSqueeze
        let reducedWidth = size.width - invertedProportionSqueeze
        return reducedWidth / size.width
    }
    
}
