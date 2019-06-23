import UIKit
import Rotary

class DancersViewController: UIViewController {
    
    @IBOutlet private weak var label: UILabel! {
        didSet {
            label.font = FontManager.body
            label.textColor = ColourManager.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColourManager.background
        
        navigationItem.title = "Dancers"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: FontManager.navigationBarLargeTitle, .foregroundColor: ColourManager.text]
        
        let optionSelectorWheelView: OptionSelectorWheelView = OptionSelectorWheelView.load()
        optionSelectorWheelView.wheelControl.rotationEnded = { [unowned self] dancer in
            self.label.attributedText = NSMutableAttributedString(string: "").normal("The current selection is ").bold(dancer.name).copy() as? NSAttributedString
        }
        optionSelectorWheelView.wheelControl.layout([
            Dancer(name: "Joanne", style: Genre(name: "Jazz")),
            Dancer(name: "Stacey", style: Genre(name: "Tap")),
            Dancer(name: "Rhian", style: Genre(name: "Lyrical")),
            Dancer(name: "Cathy", style: Genre(name: "Ballet")),
            Dancer(name: "Robin", style: Genre(name: "Street"))
            ])
        view.addSubview(optionSelectorWheelView)
        view.addConstraints(makeConstraints(forViews: ["wheel": optionSelectorWheelView, "label": label as Any]))
    }
    
    private func makeConstraints(forViews views: [String: Any]) -> [NSLayoutConstraint] {
        let wheel: OptionSelectorWheelView = views["wheel"] as! OptionSelectorWheelView
        var collector = [NSLayoutConstraint]()
        collector.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[wheel]-0-|", options: [], metrics: nil, views: views))
        let value = UIDevice.current.userInterfaceIdiom == .pad ? 800 : 400
        collector.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-(>=25@1000)-[wheel(==\(value))]", options: [], metrics: nil, views: views))
        let constraint = NSLayoutConstraint(item: wheel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        collector.append(constraint)
        return collector
    }
}
