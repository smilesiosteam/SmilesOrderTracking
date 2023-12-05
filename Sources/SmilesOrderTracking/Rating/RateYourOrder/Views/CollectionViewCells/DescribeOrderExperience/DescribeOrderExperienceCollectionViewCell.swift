//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/12/2023.
//

import UIKit
import SmilesUtilities
import PlaceholderUITextView

protocol DescribeOrderExperienceCellDelegate: AnyObject {
    func textViewDidEndTyping(_ text: String?)
}

final class DescribeOrderExperienceCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var textView: PlaceholderUITextView! {
        didSet {
            textView.textAlignment = AppCommonMethods.languageIsArabic() ? .right : .left
        }
    }
    @IBOutlet private weak var textCountLabel: UILabel! {
        didSet {
            textCountLabel.text = "0/100"
            textCountLabel.textColor = .appGreyColor_128
            textCountLabel.fontTextStyle = .smilesBody3
        }
    }
    
    // MARK: - Properties
    weak var delegate: DescribeOrderExperienceCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel, delegate: DescribeOrderExperienceCellDelegate) {
        self.delegate = delegate
        
        textView.delegate = self
        textView.attributedPlaceholder = NSAttributedString(string: viewModel.placeholderText.asStringOrEmpty(), attributes: [
            .font: UIFont.preferredFont(forTextStyle: .smilesTitle2),
            .foregroundColor: UIColor.appDarkGrayColor
        ])
    }
}

// MARK: - ViewModel
extension DescribeOrderExperienceCollectionViewCell {
    struct ViewModel {
        var placeholderText: String?
    }
}

// MARK: - UITextViewDelegate
extension DescribeOrderExperienceCollectionViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        let limitReached = updatedText.count > 100
        textView.textColor = limitReached ? .red : .primaryLabelTextColor
        return !limitReached
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCountLabel.text = "\(textView.text.count)/100"
        delegate?.textViewDidEndTyping(textView.text ?? "")
    }
}
