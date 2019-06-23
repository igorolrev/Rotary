import Foundation
import Rotary

struct Dancer: WheelOption {
    let name: String
    let style: Genre
}

extension Dancer: Equatable {
    static func == (lhs: Dancer, rhs: Dancer) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Dancer: CustomStringConvertible {
    var description: String {
        return name
    }
}

class Genre {
    let name: String
    init(name: String) {
        self.name = name
    }
}
