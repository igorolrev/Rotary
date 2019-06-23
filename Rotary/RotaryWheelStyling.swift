import UIKit

public struct RotaryWheelStyling {
    
    public let font: UIFont
    public let textColour: UIColor
    public let spindleColour: UIColor
    public let backgroundColour: UIColor
    public let innerGrooveColour: UIColor
    public let outerGrooveColour: UIColor
    
    public init(font: UIFont, textColour: UIColor, spindleColour: UIColor, backgroundColour: UIColor, innerGrooveColour: UIColor, outerGrooveColour: UIColor) {
        self.font = font
        self.textColour = textColour
        self.spindleColour = spindleColour
        self.backgroundColour = backgroundColour
        self.innerGrooveColour = innerGrooveColour
        self.outerGrooveColour = outerGrooveColour
    }
    
}
