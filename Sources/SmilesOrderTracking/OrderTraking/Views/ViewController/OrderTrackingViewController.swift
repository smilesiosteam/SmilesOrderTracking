//
//  OrderTrackingViewController.swift
//
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import UIKit
import SmilesUtilities

public final class OrderTrackingViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
   
    private let viewModel = OrderTrackingViewModel()
    private let dataSource = OrderTrackingDataSource()
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configCollectionView()
        dataSource.updateState(with: viewModel.orderStatusModel)
        collectionView.reloadData()
    }
    
    // MARK: - Functions
    private func configCollectionView() {
        [RestaurantCollectionViewCell.self,
         CashCollectionViewCell.self,
         OrderCancelledCollectionViewCell.self,
         PointsCollectionViewCell.self,
         LocationCollectionViewCell.self,
         OrderConfirmationCollectionViewCell.self,
         TextCollectionViewCell.self,
         DriverCollectionViewCell.self,
         OrderProgressCollectionViewCell.self,
         RatingCollectionViewCell.self,
         RestaurantCancelCollectionViewCell.self,
         FreeDeliveryCollectionViewCell.self,
         OrderCancelledTimerCollectionViewCell.self,
        ].forEach({
            collectionView.register(
                UINib(nibName: String(describing: $0.self), bundle: .module),
                forCellWithReuseIdentifier: String(describing: $0.self))
        })
        
        [ImageHeaderCollectionViewCell.self, MapHeaderCollectionViewCell.self].forEach({
            collectionView.register(
            UINib(nibName: String(describing: $0.self), bundle: .module),
            forSupplementaryViewOfKind: OrderConstans.headerName.rawValue,
            withReuseIdentifier: String(describing: $0.self))
        })
        
        collectionView.collectionViewLayout = OrderTrackingLayout.createLayout()
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        collectionView.contentInsetAdjustmentBehavior = .never
    }
}

// MARK: - Create
extension OrderTrackingViewController {
    static public func create() -> OrderTrackingViewController {
        let viewController = OrderTrackingViewController(nibName: String(describing: OrderTrackingViewController.self), bundle: .module)
        return viewController
    }
}
