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
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            UINib(nibName: LocationCollectionViewCell.identifier, bundle: .module),
            forCellWithReuseIdentifier: LocationCollectionViewCell.identifier)
        collectionView.collectionViewLayout = MountainLayout.createLayout()
        collectionView.dataSource = self

    }
}


extension OrderTrackingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as! LocationCollectionViewCell
//        cell.updateCell(with: .init())
        return cell
    }
    
    
}

// MARK: - Create
extension OrderTrackingViewController {
    static public func create() -> OrderTrackingViewController {
        let viewController = OrderTrackingViewController(nibName: String(describing: OrderTrackingViewController.self), bundle: .module)
        return viewController
    }
}
