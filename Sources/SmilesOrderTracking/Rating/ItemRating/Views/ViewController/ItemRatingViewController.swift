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
        setupPanGesture()
    }
    
    // MARK: - Actions
    @IBAction private func doneButtonTapped(_ sender: UIButton) {
        guard let viewModel else { return }
        if viewModel.itemWiseRating && !viewModel.doneActionDismiss {
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
        collectionView.dataSource = dataSource
        if let dataSource {
            collectionView.collectionViewLayout = dataSource.createCollectionViewLayout()
        }
    }
    
    private func bindViewModel() {
        viewModel?.$rateOrderResponse.sink { [weak self] value in
            guard let self else { return }
            
            dismiss {
                let ratingOrderResult = value?.ratingOrderResult
                let feedBackSuccessUIModel = FeedbackSuccessUIModel(popupTitle: ratingOrderResult?.title ?? "", description: ratingOrderResult?.description ?? "", boldText: ratingOrderResult?.accrualTitle ?? "")
                let feedBackSuccessViewModel = FeedbackSuccessViewModel(feedBackSuccessUIModel: feedBackSuccessUIModel)
                let feedBackSuccessViewController = FeedbackSuccessViewController.create(with: feedBackSuccessViewModel)
                feedBackSuccessViewController.modalPresentationStyle = .overFullScreen
                
                self.present(feedBackSuccessViewController)
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
            dismiss()
        }
    }
}

// MARK: - Create
extension ItemRatingViewController {
    static func create(with viewModel: ItemRatingViewModel) -> ItemRatingViewController {
        let viewController = ItemRatingViewController(nibName: String(describing: ItemRatingViewController.self), bundle: .module)
        return viewController
    }
}

// MARK: - ItemRatingDataSourceDelegate
extension ItemRatingViewController: ItemRatingDataSourceDelegate {
    func collectionViewShouldReload() {
//        collectionView.reloadData()
    }
}