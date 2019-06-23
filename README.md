<p align="center">
    <img src="Logo.png" width="480" max-width="90%" alt="Rotary" />
</p>

<p align="center">
    <a href="https://img.shields.io/badge/carthage-compatible-brightgreen.svg">
        <img src="https://img.shields.io/badge/carthage-compatible-brightgreen.svg" alt="Carthage"/>
    </a>
    <a href="https://swift.org/blog/swift-5-released/">
        <img src="https://img.shields.io/badge/swift-5.0-orange.svg" alt="Swift"/>
    </a>
</p>

## Usage

```swift
import Rotary

struct Dancer: Equatable, WheelOption {
    let name: String
    var wheelOptionTitle: String {
        return name
    }
    static func ==(lhs: Dancer, rhs: Dancer) -> Bool {
        return lhs.name == rhs.name
    }
}

let wheelControl = RotaryWheelControl<Dancer>()
wheelControl.rotationEnded = { [unowned self] dancer in
    self.label.text = "The current selection is \(dancer.name)"
}
wheelControl.layout([
    Dancer(name: "Joanne"),
    Dancer(name: "Stacey"),
    Dancer(name: "Rhian"),
    Dancer(name: "Cathy"),
    Dancer(name: "Robin")
    ])
wheelControl.styling = RotaryWheelStyling(
                                    font: <placeholder>,
                                    textColour: <placeholder>,
                                    spindleColour: <placeholder>,
                                    backgroundColour: <placeholder>,
                                    innerGrooveColour: <placeholder>,
                                    outerGrooveColour: <placeholder>
                                )
view.addSubview(wheelControl)
```

The closure 'rotationEnded' is called immediately after layout. If you do not want this behaviour, call layout before you assign the closure.
