//
//  OrderTrackingViewController.swift
//
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import UIKit

public final class OrderTrackingViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let imageHeader = "imageHeader"
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
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
         FreeDeliveryCollectionViewCell.self
        ].forEach({
            collectionView.register(
                UINib(nibName: String(describing: $0.self), bundle: .module),
                forCellWithReuseIdentifier: String(describing: $0.self))
        })
        
        collectionView.register(
            UINib(nibName: ImageHeaderCollectionViewCell.identifier, bundle: .module),
            forSupplementaryViewOfKind: imageHeader,
            withReuseIdentifier: ImageHeaderCollectionViewCell.identifier)
        
        
        collectionView.register(
            UINib(nibName: MapHeaderCollectionViewCell.identifier, bundle: .module),
            forSupplementaryViewOfKind: imageHeader,
            withReuseIdentifier: MapHeaderCollectionViewCell.identifier)
        
        collectionView.collectionViewLayout = MountainLayout.createLayout()
        collectionView.dataSource = self
        collectionView.reloadData()
        
        collectionView.contentInsetAdjustmentBehavior = .never
    }
}


extension OrderTrackingViewController: UICollectionViewDataSource, LocationCollectionViewProtocol {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch  indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as! LocationCollectionViewCell
            cell.updateCell(with: .init(), delegate: self)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCollectionViewCell.identifier, for: indexPath) as! RatingCollectionViewCell
            cell.updateCell(with: .init(cellType: .pickup))
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCollectionViewCell.identifier, for: indexPath) as! RatingCollectionViewCell
            cell.updateCell(with: .init(cellType: .delivery))
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.identifier, for: indexPath) as! DriverCollectionViewCell
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCancelCollectionViewCell.identifier, for: indexPath) as! RestaurantCancelCollectionViewCell
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderProgressCollectionViewCell.identifier, for: indexPath) as! OrderProgressCollectionViewCell
            cell.updateCell(with: .init(step: .second(percentage: 0.6), type: .orderOnWay))
            return cell
        case 6:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderProgressCollectionViewCell.identifier, for: indexPath) as! OrderProgressCollectionViewCell
            cell.updateCell(with: .init(step: .completed, type: .oderFinished))
            return cell
            
        case 7:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.identifier, for: indexPath) as! TextCollectionViewCell
            cell.updateCell(with: "Please wait while we send your order to the restaurant.")
            return cell
            
        case 8:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderConfirmationCollectionViewCell.identifier, for: indexPath) as! OrderConfirmationCollectionViewCell
            return cell
            
        case 9:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.identifier, for: indexPath) as! TextCollectionViewCell
            cell.updateCell(with: "A slight delay in your order")
            return cell
            
        case 10:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PointsCollectionViewCell.identifier, for: indexPath) as! PointsCollectionViewCell
            cell.updateCell(with: "120")
            return cell
            
        case 11:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderCancelledCollectionViewCell.identifier, for: indexPath) as! OrderCancelledCollectionViewCell
            return cell
            
        case 12:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CashCollectionViewCell.identifier, for: indexPath) as! CashCollectionViewCell
            return cell
            
        case 13:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.identifier, for: indexPath) as! RestaurantCollectionViewCell
            cell.updateCell(with: .init(items: ["Ahmed", "Naguib", "Moahmed"]))
            return cell
            
        case 14:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FreeDeliveryCollectionViewCell.identifier, for: indexPath) as! FreeDeliveryCollectionViewCell
        
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FreeDeliveryCollectionViewCell.identifier, for: indexPath) as! FreeDeliveryCollectionViewCell
        
            return cell
        }

        
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: imageHeader, withReuseIdentifier: MapHeaderCollectionViewCell.identifier, for: indexPath) as! MapHeaderCollectionViewCell
        return header
    }
    
    
}

// MARK: - Create
extension OrderTrackingViewController {
    static public func create() -> OrderTrackingViewController {
        let viewController = OrderTrackingViewController(nibName: String(describing: OrderTrackingViewController.self), bundle: .module)
        return viewController
    }
}
