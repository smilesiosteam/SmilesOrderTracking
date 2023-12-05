//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 03/12/2023.
//

import UIKit
import Combine
import SmilesUtilities

final public class RateYourOrderViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var panGesture: UIPanGestureRecognizer!
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 12.0)
        }
    }
    @IBOutlet private weak var popupHandleView: UIView! {
        didSet {
            popupHandleView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: popupHandleView.bounds.height / 2)
            popupHandleView.backgroundColor = .black.withAlphaComponent(0.2)
        }
    }
    @IBOutlet private weak var popupTitleLabel: UILabel! {
        didSet {
            popupTitleLabel.textColor = .appDarkGrayColor
            popupTitleLabel.fontTextStyle = .smilesHeadline3
        }
    }
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .fullGreyColor
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            submitButton.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 12.0)
            submitButton.setTitle(OrderTrackingLocalization.submit.text, for: .normal)
            submitButton.fontTextStyle = .smilesTitle1
        }
    }
    @IBOutlet private weak var supportTextLabel: UILabel! {
        didSet {
            supportTextLabel.text = OrderTrackingLocalization.facedTroubleWithYourOrder.text
            supportTextLabel.textColor = .appGreyColor_128
            supportTextLabel.fontTextStyle = .smilesLabel2
        }
    }
    @IBOutlet private weak var getSupportButton: UIButton! {
        didSet {
            getSupportButton.setTitle(OrderTrackingLocalization.getSupport.text, for: .normal)
            getSupportButton.setTitleColor(.appPurpleColor1, for: .normal)
            getSupportButton.fontTextStyle = .smilesLabel2
        }
    }
    
    // MARK: - Properties
    var viewModel: RateYourOrderViewModel?
    var dataSource: RateYourOrderDataSource?
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: OrderRatingViewDelegate?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appRevampFilterTextColor.withAlphaComponent(0.6)
        if let viewModel {
            dataSource = RateYourOrderDataSource(viewModel: viewModel)
        }
        dataSource?.delegate = self
        setupCollectionView()
        submitButtonState(enabled: false)
        setupPanGesture()
        bindViewModel()
        bindDataSource()
        setupUI()
    }
    
    // MARK: - Actions
    @IBAction private func submitTapped(_ sender: UIButton) {
        viewModel?.submitRating()
    }
    
    @IBAction private func getSupportTapped(_ sender: UIButton) {
        viewModel?.getLiveChatUrl()
    }
    
    // MARK: - Methods
    private func setupCollectionView() {
        [
            RatingForDisplayCollectionViewCell.self,
            ItemRatingCollectionViewCell.self,
            SeparatorLineCollectionViewCell.self,
            DescribeOrderExperienceCollectionViewCell.self
        ].forEach {
            collectionView.register(
                UINib(nibName: String(describing: $0.self), bundle: .module),
                forCellWithReuseIdentifier: String(describing: $0.self))
        }
        if let dataSource {
            collectionView.collectionViewLayout = dataSource.createCollectionViewLayout()
        }
        collectionView.dataSource = dataSource
    }
    
    private func submitButtonState(enabled: Bool) {
        if enabled {
            submitButton.backgroundColor = .appPurpleColor1
            submitButton.setTitleColor(.white, for: .normal)
            submitButton.isUserInteractionEnabled = true
        } else {
            submitButton.backgroundColor = .appButtonDisabledColor.withAlphaComponent(0.3)
            submitButton.setTitleColor(.appGreyColor_128.withAlphaComponent(0.5), for: .normal)
            submitButton.isUserInteractionEnabled = false
        }
    }
    
    private func setupPanGesture() {
        panGesture.addTarget(self, action: #selector(handlePanGesture))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let isDraggingDown = translation.y > 50
        if isDraggingDown {
            dismiss()
        }
    }
    
    private func setupUI() {
        popupTitleLabel.text = viewModel?.popupTitle
    }
    
    private func bindViewModel() {
        viewModel?.$rateOrderResponse.sink { [weak self] value in
            guard let self, let value else { return }
            
            dismiss {
                self.delegate?.shouldOpenItemRatingViewController(with: value, orderItems: self.viewModel?.rateYourOrderUIModel.ratingOrderResponse.orderItemDetails ?? [])
            }
        }.store(in: &cancellables)
        
        viewModel?.$showErrorMessage.sink { [weak self] value in
            guard let self else { return }
            self.showAlertWithOkayOnly(message: value.asStringOrEmpty())
        }.store(in: &cancellables)
        
        viewModel?.$liveChatUrl.sink { [weak self] value in
            guard let self, let value else { return }
            
            dismiss {
                self.delegate?.shouldOpenGetSupport(with: value)
            }
        }.store(in: &cancellables)
    }
    
    private func bindDataSource() {
        dataSource?.$enableDoneButton.sink { [weak self] value in
            guard let self else { return }
            self.submitButtonState(enabled: value)
        }.store(in: &cancellables)
    }
}

// MARK: - Create
extension RateYourOrderViewController {
    static func create(with viewModel: RateYourOrderViewModel, delegate: OrderRatingViewDelegate) -> RateYourOrderViewController {
        let viewController = RateYourOrderViewController(nibName: String(describing: RateYourOrderViewController.self), bundle: .module)
        viewController.viewModel = viewModel
        viewController.delegate = delegate
        return viewController
    }
}

// MARK: - RateYourOrderDataSourceDelegate
extension RateYourOrderViewController: RateYourOrderDataSourceDelegate {
    func collectionViewShouldReloadRow(at index: Int, section: RateYourOrderSection) {
        collectionView.performBatchUpdates(nil)
        
        let indexPath = IndexPath(row: index, section: section.section)
        collectionView.reloadItems(at: [indexPath])
    }
}
