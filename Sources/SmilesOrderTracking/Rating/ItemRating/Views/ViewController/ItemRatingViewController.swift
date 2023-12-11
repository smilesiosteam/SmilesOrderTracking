//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 27/11/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager
import Combine

final public class ItemRatingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 12.0)
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var doneButton: UIButton! {
        didSet {
            doneButton.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 12.0)
            doneButton.setTitle(OrderTrackingLocalization.done.text, for: .normal)
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.backgroundColor = .appPurpleColor1
            doneButton.fontTextStyle = .smilesTitle1
        }
    }
    @IBOutlet private weak var panGesture: UIPanGestureRecognizer!
    
    // MARK: - Properties
    var viewModel: ItemRatingViewModel?
    var dataSource: ItemRatingDataSource?
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: OrderRatingViewDelegate?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appRevampFilterTextColor.withAlphaComponent(0.6)
        if let viewModel {
            dataSource = ItemRatingDataSource(viewModel: viewModel)
        }
        dataSource?.delegate = self
        setupCollectionView()
        bindViewModel()
        bindDataSource()
        setupPanGesture()
        setupUI()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
    }
    
    // MARK: - Actions
    @IBAction private func doneButtonTapped(_ sender: UIButton) {
        guard let viewModel else { return }
        if !viewModel.doneActionDismiss {
            viewModel.submitRating()
        } else {
            dismiss()
        }
    }
    
    // MARK: - Methods
    private func setupCollectionView() {
        [
            FoodRatingSuccessCollectionViewCell.self,
            ItemRatingTitleCollectionViewCell.self,
            ItemRatingCollectionViewCell.self
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
    
    private func bindViewModel() {
        viewModel?.statePublisher.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .rateOrderResponse(let response):
                guard let response else { return }
                
                dismiss {
                    self.delegate?.shouldOpenFeedbackSuccessViewController(with: response)
                }
            case .showError(let message):
                self.showAlertWithOkayOnly(message: message)
            }
        }.store(in: &cancellables)
    }
    
    private func bindDataSource() {
        dataSource?.statePublisher.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .enableDoneButton(let enable):
                self.doneButtonState(enabled: enable)
            }
        }.store(in: &cancellables)
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
            NotificationCenter.default.post(name: .ReloadOrderSummary, object: nil, userInfo: nil)
            dismiss()
        }
    }
    
    private func doneButtonState(enabled: Bool) {
        if enabled {
            doneButton.backgroundColor = .appPurpleColor1
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.isUserInteractionEnabled = true
        } else {
            doneButton.backgroundColor = .appButtonDisabledColor.withAlphaComponent(0.3)
            doneButton.setTitleColor(.appGreyColor_128.withAlphaComponent(0.5), for: .normal)
            doneButton.isUserInteractionEnabled = false
        }
    }
    
    private func setupUI() {
        guard let viewModel else { return }
        if viewModel.itemRatingUIModel.orderItems.contains(where: { ($0.userItemRating ?? 0.0) > 0 }) {
            doneButtonState(enabled: true)
        } else {
            doneButtonState(enabled: false)
        }
    }
}

// MARK: - Create
extension ItemRatingViewController {
    static func create(with viewModel: ItemRatingViewModel, delegate: OrderRatingViewDelegate) -> ItemRatingViewController {
        let viewController = ItemRatingViewController(nibName: String(describing: ItemRatingViewController.self), bundle: .module)
        viewController.viewModel = viewModel
        viewController.delegate = delegate
        return viewController
    }
}

// MARK: - ItemRatingDataSourceDelegate
extension ItemRatingViewController: ItemRatingDataSourceDelegate {
    func collectionViewShouldReloadRow(at index: Int) {
        collectionView.performBatchUpdates(nil)
        
        let indexPath = IndexPath(row: index, section: ItemRatingSection.itemRating.section)
        collectionView.reloadItems(at: [indexPath])
    }
}
