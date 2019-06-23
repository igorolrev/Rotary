import UIKit

struct FontManager {
    private static let fontA = UIFont(name: "AvenirNext-DemiBold", size: UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .tv ? 40.0 : 20.0)!
    private static let fontB = UIFont(name: "AvenirNext-DemiBold", size: UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .tv ? 52.0 : 26.0)!
    private static let fontC = UIFont(name: "AvenirNext-Medium", size: UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .tv ? 48.0 : 24.0)!
    private static let fontD = UIFont(name: "AvenirNext-Regular", size: UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .tv ? 40.0 : 20.0)!
    static let navigationBarTitle = fontA
    static let subtitle = fontA
    static let emphasisedBody = fontA
    static let navigationBarLargeTitle = fontB
    static let heading = fontC
    static let body = fontD
}
