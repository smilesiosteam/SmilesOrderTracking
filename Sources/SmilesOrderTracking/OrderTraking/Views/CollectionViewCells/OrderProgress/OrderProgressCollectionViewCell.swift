//
//  OrderProgressCollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 16/11/2023.
//

import UIKit
import SmilesUtilities

final class OrderProgressCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstStepView: UIView!
    @IBOutlet private weak var secondStepView: UIView!
    @IBOutlet private weak var thirdStepView: UIView!
    @IBOutlet private weak var fourthStepView: UIView!
    
    // MARK: - Properties
    private var leadingConstraint: NSLayoutConstraint!
    private let animatedView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configControllers()
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel) {
        setProgressBar(step: viewModel.step)
        titleLabel.text = viewModel.title
        timeLabel.text = viewModel.time
        
        if viewModel.hideTimeLabel {
            timeLabel.isHidden = true
            titleLabel.fontTextStyle = .smilesHeadline2
        } else {
            timeLabel.isHidden = false
            titleLabel.fontTextStyle = .smilesHeadline4
        }
    }
    private func configControllers() {
        firstStepView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 3)
        fourthStepView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner], cornerRadius: 3)
        timeLabel.fontTextStyle = .smilesHeadline2
        titleLabel.fontTextStyle = .smilesHeadline4
    }
    private func setAllStepsWithClearColor() {
        [firstStepView, secondStepView, thirdStepView, fourthStepView].forEach({ $0?.backgroundColor = .black.withAlphaComponent(0.1) })
    }
    
//    private func fillViewWAfterStepCompleted(currentView: UIView, percentage: Double) {
//        currentView.backgroundColor = .appRevampPurpleMainColor.withAlphaComponent(0.2)
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.appRevampPurpleMainColor.cgColor, UIColor.appRevampPurpleMainColor.cgColor]
//        
//        let width = currentView.frame.width * percentage
//        let height = currentView.frame.height
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
//        currentView.layer.addSublayer(gradientLayer)
//    }
    
    private func fillResetCompletedSteps(views: [UIView]) {
        views.forEach({ $0.backgroundColor = .appRevampPurpleMainColor })
    }
    
    private func setProgressBar(step: ProgressSteps) {
        setAllStepsWithClearColor()
        switch step {
            
        case .first:
            setAnimatedView(on: firstStepView)
        case .second:
            setAnimatedView(on: secondStepView)
            fillResetCompletedSteps(views: [firstStepView])
        case .third:
            setAnimatedView(on: thirdStepView)
            fillResetCompletedSteps(views: [firstStepView, secondStepView])
        case .fourth:
            setAnimatedView(on: fourthStepView)
            fillResetCompletedSteps(views: [firstStepView, secondStepView, thirdStepView])
        case .completed:
            fillResetCompletedSteps(views: [firstStepView, secondStepView, thirdStepView, fourthStepView])
        }
    }
    
}

// MARK: - Animation
extension OrderProgressCollectionViewCell {
    private func setAnimatedView(on currentView: UIView) {
        
        animatedView.backgroundColor = .clear
        currentView.addSubview(animatedView)
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animatedView.heightAnchor.constraint(equalToConstant: 5),
            animatedView.leadingAnchor.constraint(equalTo: currentView.leadingAnchor),
        ])
        
        leadingConstraint = animatedView.trailingAnchor.constraint(equalTo: currentView.trailingAnchor, constant: 0)
        leadingConstraint.isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.leadingConstraint.constant = -currentView.frame.width
            self.animatedView.backgroundColor = .appRevampPurpleMainColor
            self.contentView.layoutIfNeeded()
            self.startFillAnimation(on: currentView)
        }
    }
    private func startFillAnimation(on currentView: UIView) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveLinear], animations: {
            
            self.leadingConstraint.constant = 0
            self.contentView.layoutIfNeeded() // Trigger layout update
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.animatedView.backgroundColor = .appRevampPurpleMainColor.withAlphaComponent(0.0)
                
                self.contentView.layoutIfNeeded()
            }) { _ in
                // Repeat the animation
                self.leadingConstraint.constant = -currentView.frame.width
                self.animatedView.backgroundColor = .appRevampPurpleMainColor
                self.contentView.layoutIfNeeded()
                self.startFillAnimation(on: currentView)
            }
        })
    }
}

extension OrderProgressCollectionViewCell {
    enum ProgressSteps {
        case first
        case second
        case third
        case fourth
        case completed
    }
    
    struct ViewModel {
        var step: ProgressSteps = .completed
        var title: String?
        var time: String?
        var hideTimeLabel = true
    }
}

