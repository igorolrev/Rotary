import CoreGraphics

extension CGPoint {
    
    /// The angle in radians between the x-axis of a 2D cartesian plane and the point parameter.
    ///
    /// - Parameter point: a point of a 2D cartesian plane.
    /// - Returns: An angle in radians. The angle is positive for counter-clockwise angles (upper half-plane, y > 0), and negative for clockwise angles (lower half-plane, y < 0).
    func angleFromLongitude(toPoint point: CGPoint) -> Float {
        let dx = Float(point.x - self.x)
        let dy = Float(point.y - self.y)
        return atan2(dx, dy)
    }
    
    /// The distance between the receiver and the point parameter.
    func distance(toPoint point: CGPoint) -> Float {
        let dx = Float(point.x - self.x)
        let dy = Float(point.y - self.y)
        let c = dx*dx + dy*dy
        return sqrt(c)
    }
    
}
