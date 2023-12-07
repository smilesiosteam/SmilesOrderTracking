

import UIKit
import SmilesUtilities

class ReasonCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RoundedViewConrner(cornerRadius: 12)
        self.cellNonSelectedState()
        titleLabel.fontTextStyle = .smilesHeadline4
        
    }
    
    func updateCell(rowModel: BaseRowModel) {
        if let _ = self.titleLabel {
            self.titleLabel.text = rowModel.rowTitle
        }
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.cellSelectedState()
                }
            }
            else {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.cellNonSelectedState()
                }
            }
        }
    }
    
    func cellSelectedState() {
        self.backgroundColor = UIColor.appRevampFilterCountBGColor.withAlphaComponent(0.2)
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }
    
    func cellNonSelectedState() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.appLightGrayColor2.withAlphaComponent(0.80).cgColor
        self.backgroundColor = .white
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }

}
