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
    override func awakeFromNib() {
        super.awakeFromNib()
        configControllers()
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel) {
        setProgressBar(step: viewModel.step)
//        titleLabel.text = viewModel.title
//        timeLabel.text = viewModel.time
        
        switch viewModel.type {
        case .orderOnWay:
            timeLabel.isHidden = false
            titleLabel.fontTextStyle = .smilesHeadline4
        case .oderFinished:
            timeLabel.isHidden = true
            titleLabel.fontTextStyle = .smilesHeadline2
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
    
    private func fillViewWAfterStepCompleted(currentView: UIView, percentage: Double) {
        currentView.backgroundColor = .appRevampPurpleMainColor.withAlphaComponent(0.2)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.appRevampPurpleMainColor.cgColor, UIColor.appRevampPurpleMainColor.cgColor]
        
        let width = currentView.frame.width * percentage
        let height = currentView.frame.height
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        currentView.layer.addSublayer(gradientLayer)
    }
    
    private func fillResetCompletedSteps(views: [UIView]) {
        views.forEach({ $0.backgroundColor = .appRevampPurpleMainColor })
    }
    
    private func setProgressBar(step: ProgressSteps) {
        setAllStepsWithClearColor()
        switch step {
            
        case .first(percentage: let percentage):
            fillViewWAfterStepCompleted(currentView: firstStepView, percentage: percentage)
        case .second(percentage: let percentage):
            fillViewWAfterStepCompleted(currentView: secondStepView, percentage: percentage)
            fillResetCompletedSteps(views: [firstStepView])
        case .third(percentage: let percentage):
            fillViewWAfterStepCompleted(currentView: thirdStepView, percentage: percentage)
            fillResetCompletedSteps(views: [firstStepView, secondStepView])
        case .fourth(percentage: let percentage):
            fillViewWAfterStepCompleted(currentView: fourthStepView, percentage: percentage)
            fillResetCompletedSteps(views: [firstStepView, secondStepView, thirdStepView])
        case .completed:
            fillResetCompletedSteps(views: [firstStepView, secondStepView, thirdStepView, fourthStepView])
        }
    }
    
}

extension OrderProgressCollectionViewCell {
    enum ProgressSteps {
        case first(percentage: Double)
        case second(percentage: Double)
        case third(percentage: Double)
        case fourth(percentage: Double)
        case completed
    }
    
    struct ViewModel {
        var step: ProgressSteps = .completed
        var title: String?
        var time: String?
        var type: CellType = .oderFinished
    }
    
    enum CellType {
        case orderOnWay
        case oderFinished
    }
}

