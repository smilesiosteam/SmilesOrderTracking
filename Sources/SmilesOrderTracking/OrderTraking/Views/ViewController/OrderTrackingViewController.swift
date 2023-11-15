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
        collectionView.register(
            UINib(nibName: LocationCollectionViewCell.identifier, bundle: .module),
            forCellWithReuseIdentifier: LocationCollectionViewCell.identifier)
        
        collectionView.register(
            UINib(nibName: DriverCollectionViewCell.identifier, bundle: .module),
            forCellWithReuseIdentifier: DriverCollectionViewCell.identifier)
        
        collectionView.register(
            UINib(nibName: ImageHeaderCollectionViewCell.identifier, bundle: .module),
            forSupplementaryViewOfKind: imageHeader,
            withReuseIdentifier: ImageHeaderCollectionViewCell.identifier)
        
        collectionView.collectionViewLayout = MountainLayout.createLayout()
        collectionView.dataSource = self

    }
}


extension OrderTrackingViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as! LocationCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.identifier, for: indexPath) as! DriverCollectionViewCell
            return cell
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: imageHeader, withReuseIdentifier: ImageHeaderCollectionViewCell.identifier, for: indexPath) as! ImageHeaderCollectionViewCell
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
