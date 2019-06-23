import UIKit

extension UIView {
    
    var radians: Double {
        return Double(atan2f(Float(transform.b), Float(transform.a)))
    }
    
}
