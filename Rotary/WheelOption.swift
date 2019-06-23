import Foundation

public protocol WheelOption {
    var wheelOptionTitle: String { get }
}

public extension WheelOption where Self: CustomStringConvertible {
    
    var wheelOptionTitle: String {
        return description
    }
}
