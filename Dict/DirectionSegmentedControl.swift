import UIKit

class DirectionSegmentedControl: UISegmentedControl {

    convenience init() {
        self.init(items: ["Rusa", "English"])
        self.tintColor = UIColor.white
        self.selectedSegmentIndex = 0
    }

}
