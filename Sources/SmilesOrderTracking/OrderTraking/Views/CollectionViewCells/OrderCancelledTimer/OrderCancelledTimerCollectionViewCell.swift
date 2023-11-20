//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 17/11/2023.
//

import UIKit

protocol OrderCancelledTimerCellActionDelegate: AnyObject {
    func likeToPickupOrderDidTap()
    func timeElapsed(count: Int)
}

final class OrderCancelledTimerCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
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
            actionButton.setTitle(OrderTrackingLocalization.orderCancelledLikeToPickupOrder.text, for: .normal)
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
    weak var delegate: OrderCancelledTimerCellActionDelegate?
    private var timer: Timer?
    var count = 900
    
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
    func updateCell(with viewModel: ViewModel) {
        delegate = viewModel.delegate
        
        count = viewModel.timerCount ?? 0
        constructTimer()
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
            delegate?.timeElapsed(count: count)
            count -= 1
        } else {
            timer?.invalidate()
            timer = nil
            timeLabel.text = "00:00" + " " + OrderTrackingLocalization.minText.text
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
        var timerCount: Int?
        var delegate: OrderCancelledTimerCellActionDelegate?
    }
}
