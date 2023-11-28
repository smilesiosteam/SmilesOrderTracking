//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 17/11/2023.
//

import UIKit

protocol OrderCancelledTimerCellActionDelegate: AnyObject {
    func likeToPickupOrderDidTap()
}

final class OrderCancelledTimerCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mainStackView: UIStackView!
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 12.0)
            containerView.addBorder(withBorderWidth: 1.0, borderColor: .black.withAlphaComponent(0.1))
        }
    }
    @IBOutlet private weak var textLabel: UILabel! {
        didSet {
            textLabel.fontTextStyle = .smilesBody2
            textLabel.textColor = .black
        }
    }
    @IBOutlet private weak var actionButton: UIButton! {
        didSet {
            actionButton.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: actionButton.bounds.height / 2)
            actionButton.fontTextStyle = .smilesHeadline4
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.backgroundColor = .appRevampPurpleMainColor
        }
    }
    @IBOutlet private weak var timeLabel: UILabel! {
        didSet {
            timeLabel.fontTextStyle = .smilesTitle1
            timeLabel.textColor = .black
        }
    }
    
    // MARK: - Properties
   private weak var delegate: OrderCancelledTimerCellActionDelegate?
    private var timer: Timer?
    private var count = 900
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - Actions
    @IBAction private func actionButtonTapped(_ sender: UIButton) {
        delegate?.likeToPickupOrderDidTap()
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel, delegate: OrderCancelledTimerCellActionDelegate) {
        self.delegate = delegate
        actionButton.setTitle(viewModel.buttonTitle, for: .normal)
        textLabel.text = viewModel.title
       
        if let timerCount = viewModel.timerCount {
            count = timerCount
            timeLabel.isHidden = false
            constructTimer()
        }  else {
            timeLabel.isHidden = true
        }
    }
    
    private func constructTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if count > 0 {
            let minutes = Int(count) / 60 % 60
            let seconds = Int(count) % 60
            timeLabel.text = String(format: "%02d:%02d", minutes, seconds) + " " + OrderTrackingLocalization.minText.text
            count -= 1
        } else {
            timer?.invalidate()
            timer = nil
            timeLabel.text = "00:00" + " " + OrderTrackingLocalization.minText.text
            textLabel.text = OrderTrackingLocalization.orderCancelledTimeFinished.text
            mainStackView.spacing = 8
            bottomConstraint.constant = 9
            topConstraint.constant = 9
            disableButton()
        }
    }
    
    private func disableButton() {
        actionButton.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
        actionButton.backgroundColor = .black.withAlphaComponent(0.1)
        actionButton.isUserInteractionEnabled = false
    }
}

// MARK: - ViewModel
extension OrderCancelledTimerCollectionViewCell {
    struct ViewModel {
        var timerCount: Int? = nil
        var title: String?
        var buttonTitle: String?
    }
}
