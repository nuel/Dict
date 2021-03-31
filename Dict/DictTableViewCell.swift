import UIKit

class DictTableViewCell: UITableViewCell {
    var originalLabel: UILabel!
    var translationLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.textLabel?.textColor = UIColor.white
        
        originalLabel = UILabel(frame: CGRect(x: 20, y: 10, width: frame.width - 20, height: 40))
        originalLabel.textColor = UIColor.white
        addSubview(originalLabel)
        
        translationLabel = UILabel(frame: CGRect(x: 20, y: 40, width: frame.width - 20, height: 40))
        translationLabel.textColor = UIColor.gray
        addSubview(translationLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
